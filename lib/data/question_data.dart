import '../models/question_model.dart';

class QuestionData {
  static final List<QuestionModel> questions = [

    // ================= Mathematics =================

    QuestionModel(
      id: "m1q1",
      subjectId: "",
      chapterId: "",
      mockTestId: "",
      subject: "MATHEMATICS",
      question: "What is the value of 15 + 25?",
      optionA: "30",
      optionB: "35",
      optionC: "40",
      optionD: "45",
      correctAnswer: "C",
      explanation: "15 + 25 = 40",
      difficulty: "Easy",
      marks: 2,
      negativeMarks: 0.5,
      isActive: true,
    ),

    QuestionModel(
      id: "m1q2",
      subjectId: "",
      chapterId: "",
      mockTestId: "",
      subject: "MATHEMATICS",
      question: "Which is a prime number?",
      optionA: "9",
      optionB: "15",
      optionC: "17",
      optionD: "21",
      correctAnswer: "C",
      explanation: "17 is a prime number.",
      difficulty: "Easy",
      marks: 2,
      negativeMarks: 0.5,
      isActive: true,
    ),

    // ================= Reasoning =================

    QuestionModel(
      id: "r1q1",
      subjectId: "",
      chapterId: "",
      mockTestId: "",
      subject: "REASONING",
      question: "Dog : Puppy :: Cat : ?",
      optionA: "Cub",
      optionB: "Kitten",
      optionC: "Calf",
      optionD: "Foal",
      correctAnswer: "B",
      explanation: "A baby cat is called Kitten.",
      difficulty: "Easy",
      marks: 2,
      negativeMarks: 0.5,
      isActive: true,
    ),

    // ================= English =================

    QuestionModel(
      id: "e1q1",
      subjectId: "",
      chapterId: "",
      mockTestId: "",
      subject: "ENGLISH",
      question: "Choose the correct spelling.",
      optionA: "Accomodation",
      optionB: "Accommodation",
      optionC: "Acommodation",
      optionD: "Acomodation",
      correctAnswer: "B",
      explanation: "Accommodation is the correct spelling.",
      difficulty: "Easy",
      marks: 2,
      negativeMarks: 0.5,
      isActive: true,
    ),

    // ================= Hindi =================

    QuestionModel(
      id: "h1q1",
      subjectId: "",
      chapterId: "",
      mockTestId: "",
      subject: "HINDI",
      question: "'राम' किस प्रकार की संज्ञा है?",
      optionA: "जातिवाचक",
      optionB: "व्यक्तिवाचक",
      optionC: "भाववाचक",
      optionD: "समूहवाचक",
      correctAnswer: "B",
      explanation: "राम एक व्यक्तिवाचक संज्ञा है।",
      difficulty: "Easy",
      marks: 2,
      negativeMarks: 0.5,
      isActive: true,
    ),

    // ================= General Knowledge =================

    QuestionModel(
      id: "g1q1",
      subjectId: "",
      chapterId: "",
      mockTestId: "",
      subject: "GENERAL KNOWLEDGE",
      question: "Who is known as the Father of the Nation in India?",
      optionA: "Jawaharlal Nehru",
      optionB: "Subhas Chandra Bose",
      optionC: "Mahatma Gandhi",
      optionD: "Sardar Patel",
      correctAnswer: "C",
      explanation: "Mahatma Gandhi is known as the Father of the Nation.",
      difficulty: "Easy",
      marks: 2,
      negativeMarks: 0.5,
      isActive: true,
    ),
  ];
}