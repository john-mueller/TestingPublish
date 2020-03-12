import Foundation
import Publish
import Plot

// This type acts as the configuration for your website.
struct TestingPublish: Website {
    enum SectionID: String, WebsiteSectionID {
        // Add the sections that you want your website to contain here:
        case posts
    }

    struct ItemMetadata: WebsiteItemMetadata {
        // Add any site-specific metadata that you want to use here.
    }

    // Update these properties to configure your website:
    var url = URL(string: "https://john-mueller.github.io/TestingPublish/")!
    var name = "TestingPublish"
    var description = "A description of TestingPublish"
    var language: Language { .english }
    var imagePath: Path? { nil }
}

// This will generate your website using the built-in Foundation theme:
let indentation: Indentation.Kind? = .spaces(2)

let plugins: [Plugin<TestingPublish>] = [
]

let preGenerationSteps: [PublishingStep<TestingPublish>] = [
]

let postGenerationSteps: [PublishingStep<TestingPublish>] = [
    .step(named: "Fix CSS") { context in
        do {
            let root = try context.folder(at: "")
            let files = root.files.recursive
            for file in files where file.extension == "html" {
                let html = try file.readAsString()
                let fixed = html.replacingOccurrences(of: "/styles.css", with: "styles.css")
                try file.write(fixed)
            }
        } catch {
            print(error)
        }
    }
]

try TestingPublish().publish(using: [
    .group(plugins.map(PublishingStep.installPlugin)),
    .optional(.copyResources()),
    .addMarkdownFiles(),
    .sortItems(by: \.date, order: .descending),
    .group(preGenerationSteps),
    .generateHTML(withTheme: .foundation, indentation: indentation),
    .generateRSSFeed(including: Set(TestingPublish.SectionID.allCases)),
    .generateSiteMap(indentedBy: indentation),
    .group(postGenerationSteps),
    .unwrap(DeploymentMethod.gitHubPages(
        "john-mueller/TestingPublish",
        on: .master,
        useSSH: true
    ), PublishingStep.deploy)
])
