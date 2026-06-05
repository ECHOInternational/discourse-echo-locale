# name: ECHO Locale
# about: Customization hacks. Removes search icon.
# version: 3.0.1
# authors: Nate Flood for ECHO Inc

# javascript
register_asset "stylesheets/hacks.css"

# gem "http_accept_language", "2.0.5"

after_initialize do
	# match the supported locales to the main site.
	# LocaleSiteSetting.class_eval do
	#   def self.supported_locales
	#     %w(en es fr my vi th zh zh_CN sw id km)
	#   end
	# end

	# Prepend (not class_eval/redefine) so `super` reaches Discourse's real
	# `with_resolved_locale`. Reopening ApplicationController and redefining the
	# method would clobber the original and make `super` fail.
	module ::EchoLocale
		module LocaleResolver
			# Map main-site locale codes onto the locales Discourse actually ships
			# (e.g. zh -> zh_CN; my/th/sw/km have no Discourse translation -> en).
			# Unknown codes pass through unchanged so already-supported locales
			# (zh_CN, pt, etc.) are not discarded.
			def map_locale(locale)
				case locale.to_s
				when "zh"
					"zh_CN"
				when "my", "th", "sw", "km"
					"en"
				else
					locale.to_s
				end
			end

			# Discourse resolves locale via the `with_resolved_locale` around_action
			# (there is no `set_locale` to override). When the main site drives the
			# forum's language through the `?locale=` param the ECHO nav/locale JS
			# appends, honor it here and apply `map_locale` before yielding;
			# otherwise defer to Discourse's native resolution (user pref /
			# accept-language / cookie / default) via super.
			def with_resolved_locale(check_current_user: true)
				requested = params[:locale]
				if requested.present?
					mapped = map_locale(requested)
					if mapped.present? && I18n.locale_available?(mapped)
						I18n.ensure_all_loaded!
						return I18n.with_locale(mapped) { yield }
					end
				end
				super
			end

			def default_url_options(options = {})
				{ locale: I18n.locale }
			end
		end
	end

	ApplicationController.prepend(EchoLocale::LocaleResolver)
end