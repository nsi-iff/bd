# Override the directories that the
# SourceAnnotationExtractor traverses
# when you call rake notes
#class SourceAnnotationExtractor
#  def find_with_custom_directories
#    find_without_custom_directories(%w(app config lib script test spec))
#  end
#  alias_method_chain :find, :custom_directories
#end
