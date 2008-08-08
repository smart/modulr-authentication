#Implement the ability to order the authentication order
#YouserAuthentication::authentication_order = [:local_user, :facebook, :openid]

#Load each authenticator
require 'youser_authentication'

#YouserAuthentication::load_modules

#YouserAuthentication::authenticators = YouserAuthentication::authenticator_order.collect do |auth|
#  require "youser_authenticator_#{}{auth}"
#end

