class SessionsController < ApplicationController
#  def login
    #render :nothing => true
#    render :text => 'hello'
#  end

  def create
    email = params[:login][:email]
    type = params[:login][:type]
    if type == 'tester'
      user = User.find_by(email: email)
      if user
        session[:user] = user
        redirect_to scenarios_path
        return
      else
        flash[:error] = 'There was an error with your email.'
      end
    elsif type == 'researcher'
      researcher = Researcher.find_by(email: email)
      if researcher
        session[:researcher] = researcher
        redirect_to scenarios_path
        return
      else
        flash[:error] = 'There was an error with your email.'
      end
    else
      flash[:error] = 'There was an error with your type.'
    end
    redirect_to login_path
  end

  def destroy
    session[:user] = nil
    session[:researcher] = nil
    redirect_to root_path
  end
end
