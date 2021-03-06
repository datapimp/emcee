module Emcee
  module Processors
    # ScriptProcessor scans a document for external script references and inlines
    # them into the current document.
    class ScriptProcessor
      def initialize(resolver)
        @resolver = resolver
      end

      def process(doc)
        inline_scripts(doc)
        doc
      end

      private

      def inline_scripts(doc)
        doc.css("script[src]").each do |node|
          path = absolute_path(node.attribute("src"))
          return unless @resolver.should_inline?(path)
          content = @resolver.evaluate(path)
          script = doc.create_node("script", content)
          node.replace(script)
        end
      end

      def absolute_path(path)
        File.absolute_path(path, @resolver.directory)
      end
    end
  end
end
