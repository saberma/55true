module QuestionsHelper
  def populate_num(answer)
    num = answer.question.populate
    num = (num > 0) ? "(#{num})" : ""
    "=>顶#{num}<="
  end
end
