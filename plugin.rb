# name: ECHO Locale
# about: Customization hacks. Removes search icon.
# version: 2.0.0
# authors: Nate Flood for ECHO Inc

# javascript
register_asset "stylesheets/hacks.css"

gem "http_accept_language", "2.0.5"

after_initialize do
	# match the supported locales to the main site.
	# LocaleSiteSetting.class_eval do
	#   def self.supported_locales
	#     %w(en es fr my vi th zh zh_CN sw id km)
	#   end
	# end

	ApplicationController.class_eval do 
		def set_locale
			begin
				detected_locale = params[:locale] || http_accept_language.compatible_language_from(I18n.available_locales) || I18n.default_locale
				I18n.locale = map_locale(detected_locale)
			rescue I18n::InvalidLocale
				I18n.locale = I18n.default_locale
			end
			I18n.ensure_all_loaded!
		end

		def map_locale(locale)
			case locale.to_s
			when "en", "es", "fr", "vi", "id"
				locale
			when "zh"
				"zh_CN"
			when "my", "th", "sw", "km"
				"en"
			end
		end

		def default_url_options(options={})
		  { locale: I18n.locale }
		end

	end
end