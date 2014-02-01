QcircuitGui::Application.routes.draw do
  root :to => 'global#home'
  get 'latex/formula/:code.png' => 'latex#render_formula', code: /[0-9a-f]+/, as: 'latex_render_formula'
end
