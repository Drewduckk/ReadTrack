class ReadingProgressPolicy < ApplicationPolicy
  def show?
    user&.admin? || (record.student_id == user&.id) || (record.reading_assignment&.teacher_id == user&.id)
  end

  def create?
    user&.student? || user&.admin?
  end

  def update?
    user&.admin? || (record.student_id == user&.id)
  end
end
