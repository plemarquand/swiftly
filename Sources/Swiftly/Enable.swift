import ArgumentParser
import SwiftlyCore
import Foundation

struct Enable: SwiftlyCommand {
    public static var configuration = CommandConfiguration(
        abstract: "Enable swiftly."
    )

    @Argument(help: ArgumentHelp(
        "Enables swiftly if it has been disabled.",
        discussion: """

        Enables swiftly if it has been disabled.
        """
    ))
    var toolchainSelector: String?

    @OptionGroup var root: GlobalOptions

    mutating func run() async throws {
        try await self.run(Swiftly.createDefaultContext())
    }

    mutating func run(_ ctx: SwiftlyCoreContext) async throws {
        try validateSwiftly(ctx)

        var config = try Config.load(ctx)
        let toolchainVersion = try await Install.determineToolchainVersion(
            ctx,
            version: nil,
            config: &config
        )

        let _ = try Install.setupProxies(
            ctx,
            version: toolchainVersion, 
            verbose: self.root.verbose,
            assumeYes: self.root.assumeYes
        )
    }
}
