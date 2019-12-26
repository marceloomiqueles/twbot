Twbot::Application.routes.draw do
  root    'bots#index'

  get     '/bot/nuevo'                              => 'bots#nuevo'           , as: '/bot/nuevo'
  post    '/bot/guardar'                            => 'bots#guardar'         , as: '/bot/guardar'
  get     '/bot/:id/editar'                         => 'bots#editar'          , as: '/bot/editar'
  patch   '/bot/:id/editar'                         => 'bots#actualizar'      , as: '/bot/actualizar'
  get     '/bot/eliminar/:id'                       => 'bots#eliminar'        , as: '/bot/eliminar'
  get     '/bot/on/:id'                             => 'bots#bot_on'          , as: '/bot/on'
  get     '/bot/off/:id'                            => 'bots#bot_off'         , as: '/bot/off'
  post    '/bot/login'                              => 'bots#login'           , as: '/bot/login'

  get     '/bot/:id/palabras'                       => 'bots#palabras'        , as: '/bot/palabras'
  get     '/bot/:id/palabras/agregar'               => 'bots#agregar_palabra' , as: '/bot/agregar/palabra'
  post    '/bot/:id/palabras/agregar'               => 'bots#guardar_palabra' , as: '/bot/agregar/palabra-guardar'
  delete  '/bot/:id/palabras/eliminar/:palabra_id'  => 'bots#eliminar_palabra', as: '/bot/eliminar/palabra'

  get     '/bot/:id/ciudades'                       => 'bots#ciudades'        , as: '/bot/ciudades'
  get     '/bot/:id/ciudades/add/:id_ciudad'        => 'bots#agregar_ciudad'  , as: '/bot/ciudades/add'
  delete  '/bot/:id/ciudades/del/:id_botciudad'     => 'bots#eliminar_ciudad' , as: '/bot/ciudades/del'

  get     '/bot/:id/tweets'                         => 'bots#tweets'          , as: '/bot/tweets'
  get     '/bot/:id/tweets/detalle/:tweet_id'       => 'bots#tweet_detalle'   , as: '/bot/tweet/detalle'
  get     '/bot/:id/tweets/unfollow/:tweet'         => 'bots#unfollow'        , as: '/bot/tweets/unfollow'
  get     '/bot/:id/tweets/follow/:tweet'           => 'bots#follow'          , as: '/bot/tweets/follow'

  post    '/password/forgot'                         => 'passwords#forgot'      , as: 'password/forgot'
  post    '/password/reset'                          => 'passwords#reset'       , as: 'password/reset'

  get     '/auth/:provider/callback'                => 'bots#auth'
  get     '/auth/failure'                           => 'bots#fail_auth'

  get     '/ciudades'                               => 'ciudades#index'
  get     '/ciudades/nueva'                         => 'ciudades#nueva'       , as: '/ciudades/nueva'
  post    '/ciudades/nueva'                         => 'ciudades#guardar'     , as: '/ciudades/guardar'
  get     '/ciudades/editar/:id'                    => 'ciudades#editar'      , as: '/ciudades/editar'
  patch   '/ciudades/editar/:id'                    => 'ciudades#actualizar'  , as: '/ciudades/actualizar'
  delete  '/ciudades/eliminar/:id'                  => 'ciudades#eliminar'    , as: '/ciudades/eliminar'
end