# DeployIt - Docker containers management software
# Copyright (C) 2015 Nicolas Rodriguez (nrodriguez@jbox-web.com), JBox Web (http://www.jbox-web.com)
#
# This code is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License, version 3,
# as published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License, version 3,
# along with this program.  If not, see <http://www.gnu.org/licenses/>

class ApplicationCreationWizardForm

  include ActiveModel::Model

  attr_reader :object


  def initialize(object_or_class, session, params = nil, param_key = nil)
    @object_or_class = object_or_class
    @session         = session
    @params          = params
    @param_key       = param_key || ActiveModel::Naming.param_key(object_or_class)
    @session_params  = "#{@param_key}_params".to_sym
  end


  def start
    @session[@session_params] = {}
    set_object
    @object.current_step = @session['creation_step'] = 'select_params'
  end


  def process
    @session[@session_params].deep_merge!(@params[@param_key]) if @params[@param_key]
    set_object
    @object.current_step = @session['creation_step']
    @object.assign_attributes(@session[@session_params]) unless class?
  end


  def save
    if @params[:back_button]
      @object.step_back
      @session['creation_step'] = @object.current_step
      @object
    elsif @object.current_step_valid?
      return process_save
    end
    false
  end


  private


    def set_object
      @object = class? ? @object_or_class.new(@session[@session_params]): @object_or_class
    end


    def class?
      @object_or_class.is_a?(Class)
    end


    def process_save
      if @object.last_step?
        if @object.all_steps_valid?
          success = @object.save
          @session[@session_param] = nil
          return success
        end
      else
        @object.step_forward
        @session['creation_step'] = @object.current_step
        @object
      end
      false
    end

end
