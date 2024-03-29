module Elm
  module Rails
    module Helper
      def elm_embed(module_name, args = {})
        content_tag(:div) do
          component_div + script_tag(module_name, args)
        end
      end

      private

      def component_div
        content_tag(:div) {}
      end

      def script_tag(module_name, args)
        content_tag(:script, raw(<<-HTML), type: "text/javascript")
          (function() {
            var onLoad = function(func) {
              if (window.attachEvent) {
                console.log("attachEvent");
                console.log(yourFunctionName);
                window.attachEvent('onload', yourFunctionName);
              } else {
                if (window.onload) {
                  var curronload = window.onload;
                  var newonload = function(evt) {
                    curronload(evt);
                    func(evt);
                  };
                  window.onload = newonload;
                } else {
                  window.onload = func;
                }
              }
            };

            var currentScript = document.currentScript || (function() {
              var scripts = document.getElementsByTagName("script");
              return scripts[scripts.length - 1];
            })();

            var embedDiv = currentScript.previousSibling;

            onLoad(function() {
              var args = #{raw args.to_json};
              args.node = embedDiv;
              window.#{raw module_name} = #{raw module_name}.init(args)
            });
          })();
        HTML
      end
    end
  end
end
