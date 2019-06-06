# Display a friendly welcoming message to non-contributors
contributors = github.api.contributors("SwiftCommon/DataKit").map { |user| user.login }

unless contributors.include? github.pr_author
  message "Hi @#{github.pr_author} 👋! Thank you for contributing to SwiftCommon/DataKit! I'm the CautionWarningBot triggered by the CI for this project, and will assist you is getting this PR merged ☀️"
end

# Ignore/override Danger assertions that fail the build with the PR description.
declared_dev_known = (github.pr_body).include?("#known")
warn "Developer overridden Danger assertions. Shown as warnings still. 🤷‍♂️" if declared_dev_known

# Log an error or warning when developer declared #known in pr body
def failOrWarn(text, pass_build)
  fail text unless pass_build
  warn "[KNOWN 🤫] #{text}" if pass_build
end

# Check for protected files updated
files.protect_files(path: "Dangerfile", message: "📛 Dangerfile modified", fail_build: false, callback: method(:failOrWarn))
files.protect_files(path: ".swiftlint.yml", message: "💄 .swiftlint modified", fail_build: false, callback: method(:failOrWarn))
files.protect_files(path: ".jazzy.yml", message: "🎵 .jazzy modified", fail_build: false, callback: method(:failOrWarn))
files.protect_files(path: ".gitignore", message: "🙈 .gitignore modified", fail_build: false, callback: method(:failOrWarn))
files.protect_files(path: "LICENSE", message: "📃 LICENSE modified", fail_build: !declared_dev_known, callback: method(:failOrWarn))
files.protect_files(path: ".travis.yml", message: "👷‍♀️ Travis-CI configuration modified", fail_build: !declared_dev_known, callback: method(:failOrWarn))

# Protect fastlane .env files
files.protect_files(path: "fastlane/.env", message: "🏎  Fastlane file modified (.env)", fail_build: !declared_dev_known, callback: method(:failOrWarn))
files.protect_files(path: "fastlane/.env.default", message: "🏎  Fastlane file modified (.env.default)", fail_build: !declared_dev_known, callback: method(:failOrWarn))
files.protect_files(path: "fastlane/.env.ios12_xcode10", message: "🏎  Fastlane file modified (.env.ios12_xcode10)", fail_build: !declared_dev_known, callback: method(:failOrWarn))
files.protect_files(path: "fastlane/.env.osx", message: "🏎  Fastlane file modified (.env.osx)", fail_build: !declared_dev_known, callback: method(:failOrWarn))
files.protect_files(path: "fastlane/Fastfile", message: "🏎  Fastlane file modified (Fastfile)", fail_build: !declared_dev_known, callback: method(:failOrWarn))

# Ensure a clean commits history
if git.commits.any? { |c| c.message =~ /^Merge branch '#{github.branch_for_base}'/ }
  failOrWarn("Please rebase to get rid of the merge commits in this PR 🙏", declared_dev_known)
end

# Mainly to encourage writing up some reasoning about the PR, rather than
# just leaving a title
if github.pr_body.length < 15
  failOrWarn("Please provide a summary in the Pull Request description ✍️", declared_dev_known)
end

modified_files = git.modified_files + git.added_files

# Warn when there is a big PR
# only count changes not in docs/ or project files
modified_files_not_docs = git.diff.stats[:files].select { |info|
  (file, _) = info
  !(file =~ /^(?!docs\/).*$/).nil? && !(file =~ /^(?!.+\.xcodeproj\/).*$/).nil?
}.map { |info|
  (file, stats) = info
  {:file => file, :changes => stats[:insertions] + stats[:deletions] }
}
modified_lines_not_docs = modified_files_not_docs.map { |info| info[:changes] }.reduce { |acc, changes| acc + changes }
warn "Your PR has over 400 lines of code changes 😱 (excluding docs/ and DataKit.xcodeproj/). Please consider splitting into separate PRs if possible 👍" if modified_lines_not_docs > 400

# If these are all empty something has gone wrong, better to raise it in a comment
if modified_files.empty? && git.deleted_files.empty?
  failOrWarn("This PR has no changes at all 🧐, this is likely an issue during development. 🚧", !declared_dev_known)
end

# Sometimes its a README fix, or something like that - which isn't relevant for
# including in a CHANGELOG for example
has_app_changes = !modified_files.grep(/Sources/).empty?
has_test_changes = !modified_files.grep(/Tests/).empty?

# Let people say that this isn't worth a CHANGELOG entry in the PR if they choose
declared_trivial = (github.pr_title + github.pr_body).include?("#trivial") || !has_app_changes

# Add a CHANGELOG entry for app changes
if !modified_files.include?('CHANGELOG.md') && has_app_changes && !declared_trivial
  warn("Please include a CHANGELOG entry to credit yourself! 🤗 \nYou can find it at [CHANGELOG.md](https://github.com/SwiftCommon/DataKit/blob/master/CHANGELOG.md).")
end

# If changes are more than 50 lines of code, tests might need to be updated too
if has_app_changes && !has_test_changes && modified_lines_not_docs > 50
  warn("Tests were not updated 🤨, are you sure all is still tested? Codecov.io 🕵️‍♂️ will hunt you down if not...", sticky: false)
end

# Warn for missing docs update
#missing_doc_changes = modified_files.grep(/docs/).empty?
#doc_changes_recommended = git.insertions > 15
#if has_app_changes && missing_doc_changes && doc_changes_recommended && !declared_trivial
#  warn("Consider adding supporting documentation to this change 📖. Documentation can be found in the `docs` directory.\n👉 And can be generated with `$ jazzy --config .jazzy.yml`")
#end

# Check when Gemfile is updated that the Gemfile.lock file is also updated
gem_updated = manifest.manifest_file(name: "Gemfile", path: /Gemfile/, modified_file_list: modified_files)
gem_lock_updated = manifest.manifest_file(name: "Gemfile.lock", path: /Gemfile.lock/, modified_file_list: modified_files)

if (!gem_updated.updated && gem_lock_updated.updated) || (gem_updated.updated && !gem_lock_updated.updated)
  failOrWarn("Gemfile or Gemfile.lock is updated, but not both. 🤥", declared_dev_known)
end

# Warn when any of the package manifest(s) updated but not others
# podspec_updated = manifest.manifest_file(name: "DataKit.podspec", path: /DataKit.podspec/, modified_file_list: modified_files) TODO
# cartfile_updated = manifest.manifest_file(name: "Cartfile", path: /Cartfile$/, modified_file_list: modified_files) TODO
# cartfile_resolved_updated = manifest.manifest_file(name: "Cartfile.resolved", path: /Cartfile.resolved/, modified_file_list: modified_files) TODO
package_updated = manifest.manifest_file(name: "Package.swift", path: /Package.swift/, modified_file_list: modified_files)
package_resolved_updated = manifest.manifest_file(name: "Package.resolved", path: /Package.resolved/, modified_file_list: modified_files)

manifests = [
    # podspec_updated,
    # cartfile_updated,
    # cartfile_resolved_updated,
   package_updated,
   package_resolved_updated
]

manifest.check_manifests(manifests, fail_build: !declared_dev_known)

# This is swiftlint plugin. More info: https://github.com/ashfurrow/danger-ruby-swiftlint
#
# This lints all Swift files and leave comments in PR if
# there is any issue with linting
swiftlint.lint_files inline_mode: true

# LGTM when no errors are found
lgtm.check_lgtm
