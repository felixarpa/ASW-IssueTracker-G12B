class SessionsController < ApplicationController
    def create
        #guardem a auth el que rebem de la API quan fem login
        auth = request.env["omniauth.auth"]
        session[:omniauth] = auth.except('extra')
        #guardem els atributs necesaris del usuari logejat
        user = User.sign_in_from_omniauth(auth)
        session[:user_id] = user.id
        redirect_to root_url, notice: "SIGNED IN"
    end
    def destroy
        session[:user_id] = nil
        session[:omniauth] = nil
        redirect_to root_url, notice: "SIGNED OUT"
    end
end
