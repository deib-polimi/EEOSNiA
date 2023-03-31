import Foundation
import ArgumentParser
import CarthageKit

@main
public struct CarthageAnalyzer {
    
    struct CarthageAnalyzer: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "A Swift command-line tool to convert Cartfiles to JSON"
        )
        
        @Argument(help: "The input Cartfile")
        var file: String
        
        func run() throws {
            let filePath = file
            
            let fileContents = try String(contentsOfFile: filePath)
            Carthage().computeDependencies(input: fileContents)
        }
    }
    
    struct Carthage {
        func computeDependencies(input: String) {
            var dependencies: [Dependency] = []
            
            let cartfile = Cartfile.from(string: input)
            
            if let result = cartfile.result.value {
                for dep in result.dependencies {
                    dependencies.append(Dependency(name: dep.key.description, version: dep.value.description))
                }
            }
            do {
                let output = try JSONEncoder().encode(dependencies)
                print(String(data: output, encoding: .utf8)!)
            } catch {
                print("Invalid input file")
            }
        }
        
        struct Dependency: Encodable {
            let name: String
            let version: String
        }
    }
    
    public static func main() {
        CarthageAnalyzer.main()
    }
}
