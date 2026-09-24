class SummaryPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    user&.admin? || (user&.teacher? && record.reading_assignment&.teacher_id == user.id) || (record.student_id == user&.id)
  end

  def create?
    user&.student? || user&.admin?
  end

  def new?
    create?
  end

  def update?
    user&.admin? || (record.student_id == user&.id)
  end

  def edit?
    update?
  end

  def destroy?
    user&.admin? || (record.student_id == user&.id)
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user&.admin?
        scope.all
      elsif user&.teacher?
        scope.joins(:reading_assignment).where(reading_assignments: { teacher_id: user.id })
      elsif user&.student?
        scope.where(student_id: user.id)
      else
        scope.none
      end
    end
  end
end
