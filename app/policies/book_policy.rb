class BookPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    user.present?
  end

  def create?
    user&.teacher? || user&.admin?
  end

  def new?
    create?
  end

  def update?
    user&.teacher? || user&.admin?
  end

  def edit?
    update?
  end

  def destroy?
    user&.admin?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.present?
        scope.all
      else
        scope.none
      end
    end
  end
end