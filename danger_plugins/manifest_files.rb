module Danger
  class Manifest < Plugin
    # Wrapper for package manifest file name and update status
    PackageManifest = Struct.new(:fileName, :updated)

    def manifest_file(name: nil, path: nil, modified_file_list: [])
      raise "You have to provide a name" if name.to_s.empty?
      raise "You have to provide the path pattern (grep)" if path.to_s.empty?

      updated = !modified_file_list.grep(path).empty?

      PackageManifest.new(name, updated)
    end

    def check_manifests(manifest_files, fail_build: true)
      updated_manifests = manifest_files.select { |e| e.updated }
      not_updated_manifests = manifest_files.select { |e| !e.updated }

      if !updated_manifests.empty?
        message "Package manifests have changed. This shouldn't happend to often.\n\tChanges: [\n" + updated_manifests.map { |manifest| "\t\t * #{manifest.fileName}" }.join("\n") + "\n\t]\n"
      end
      if !updated_manifests.empty? && !not_updated_manifests.empty?
        message = manifests_warning_message(updated: updated_manifests, not_updated: not_updated_manifests)
        if fail_build
          fail message
        else
          warn message
        end
      end
    end

    # Well formatted, comma separated list of package manifest(s)
    def format_manifests(manifests)
        return "" if manifests.empty?
        formatted = manifests.map { |e| "`#{e.fileName}`" }
        return formatted.first if formatted.size == 1
        output = formatted.join(', ')
        output[output.rindex(',')] = ' and'
        return output
    end

    # Warning message for not updated package manifest(s)
    def manifests_warning_message(updated:, not_updated:)
        return "Unable to construct warning message." if updated.empty? || not_updated.empty?
        updated_manifests_names = format_manifests(updated)
        not_updated_manifests_names = format_manifests(not_updated)
        updated_article = updated.size == 1 ? "The " : ""
        updated_verb = updated.size == 1 ? "was" : "were"
        not_updated_article = not_updated.size == 1 ? "the " : ""
        output = "#{updated_article}#{updated_manifests_names} #{updated_verb} updated, " \
                 "but there were no changes in #{not_updated_article}#{not_updated_manifests_names}.\n"\
                 "Did you forget to update #{not_updated_manifests_names}?"
        return output
    end
  end
end
