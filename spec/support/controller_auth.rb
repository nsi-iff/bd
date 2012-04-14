module ControllerAuth
  def autorizar_tudo
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    @ability.stub(:can?).and_return(true)
    controller.stub(:current_ability) { @ability }
  end

  def login(usuario)
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    sign_in usuario
  end
end
