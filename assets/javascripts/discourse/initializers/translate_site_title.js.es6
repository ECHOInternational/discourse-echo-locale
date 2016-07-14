export default {
	name: 'translate_site_title',
	initialize() {
		Discourse.SiteSettings.title = I18n.t('site_title');
	}
}