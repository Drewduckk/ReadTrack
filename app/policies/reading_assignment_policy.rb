class ReadingAssignmentPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    user.present?
  end

  def read?
    user.present?
  end

  def create?
    user&.teacher? || user&.admin?
  end

  def new?
    create?
  end

  def update?
    user&.admin? || (user&.teacher? && record.teacher_id == user.id)
  end

  def edit?
    update?
  end

  def destroy?
    user&.admin? || (user&.teacher? && record.teacher_id == user.id)
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user&.admin?
        scope.all
      elsif user&.teacher?
        scope.where(teacher_id: user.id)
      elsif user&.student?
        scope.all
      else
        scope.none
      end
    end
  end
end
