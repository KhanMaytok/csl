class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    
       user ||= Employee.new # guest user (not logged in)
       #admin
       if user.is? :admin
         can :manage, :all
       end

       #sistemas
       if user.is? :sistemas
         can :manage, :all
       end

       #facturacion
       if user.is? :fact
         can :manage, PayDocument
         can :manage, InsuredService
         can :manage, InsuredPharmacy
         can :manage, Authorization
         can :manage, Patient
         can :manage, PurchaseCoverageService
         can :manage, PayDocumentGroup
         can :manage, Coverage
         can :read, Employee
       end

       if user.is? :farm
        can :read, PayDocument
        can :update, Authorization
        can :update, Coverage
       end

    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
