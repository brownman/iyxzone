ActionController::Dispatcher.middleware.use(FlashSessionCookieMiddleware, ActionController::Base.session_options[:key])
