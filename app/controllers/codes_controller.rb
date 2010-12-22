class CodesController < InheritedResources::Base
  actions :index
  prepend_before_filter :authenticate_user!

  protected
  def begin_of_association_chain
    current_user
  end

end
