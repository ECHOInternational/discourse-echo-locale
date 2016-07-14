# name: ECHO Locale
# about: Customization hacks. Removes search icon.
# version: 0.2.0
# authors: Nate Flood for ECHO Inc

# javascript
register_asset "stylesheets/hacks.css"

gem "http_accept_language", "2.0.5"

after_initialize do
	ApplicationController.class_eval do 
		def set_locale
			begin	
				I18n.locale = params[:locale] || http_accept_language.compatible_language_from(I18n.available_locales) || I18n.default_locale
			rescue I18n::InvalidLocale
				I18n.locale = I18n.default_locale
			end
			I18n.ensure_all_loaded!
		end

		def default_url_options(options={})
		  { locale: I18n.locale }
		end

	end
end