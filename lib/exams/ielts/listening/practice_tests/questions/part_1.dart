final List<Map<String, dynamic>> questions = [
  {
    "title": "Everyday Conversations",
    "subtitle": "Part 1",
    "description": "Listen to everyday conversations and answer questions.",
    "duration": "10 minutes",
    "audioUrl": "ielts/listening/practice_tests/part1.mp3",
    "allQuestions": [
      // Personal Information Questions
      {
        "question": "What is the name of the language college?",
        "options": [
          "Central Language School",
          "Central Language College",
          "City Language College",
          "Global Language Center",
        ],
        "correctAnswer": "Central Language College",
        "difficulty": "easy",
        "type": "detail",
      },
      {
        "question": "What is the student's name?",
        "options": ["Nirinsha", "Nirisha", "Nirinsa", "Nirinshaa"],
        "correctAnswer": "Nirinsha",
        "difficulty": "easy",
        "type": "spelling",
      },
      {
        "question": "How does the student spell her name?",
        "options": [
          "N-I-R-I-N-S-H-A",
          "N-I-R-I-S-H-A",
          "N-I-R-I-N-S-A",
          "N-I-R-I-N-S-H-A-A",
        ],
        "correctAnswer": "N-I-R-I-N-S-H-A",
        "difficulty": "medium",
        "type": "spelling",
      },

      // Course Information Questions
      {
        "question": "What type of course is the student mainly interested in?",
        "options": [
          "Business English",
          "Exam preparation",
          "General English",
          "Academic English",
        ],
        "correctAnswer": "General English",
        "difficulty": "easy",
        "type": "detail",
      },
      {
        "question": "Which skills does the student want to improve most?",
        "options": [
          "Reading and writing",
          "Speaking and listening",
          "Grammar and vocabulary",
          "Pronunciation and fluency",
        ],
        "correctAnswer": "Speaking and listening",
        "difficulty": "easy",
        "type": "detail",
      },
      {
        "question": "Why does the student prefer a part-time course?",
        "options": [
          "She has family commitments",
          "She's working in the afternoons",
          "She studies at another college",
          "She prefers shorter classes",
        ],
        "correctAnswer": "She's working in the afternoons",
        "difficulty": "medium",
        "type": "detail",
      },

      // Schedule Questions
      {
        "question": "What time do the morning classes run?",
        "options": [
          "8 a.m. to 11 a.m.",
          "9 a.m. to 12 p.m.",
          "10 a.m. to 1 p.m.",
          "9:30 a.m. to 12:30 p.m.",
        ],
        "correctAnswer": "9 a.m. to 12 p.m.",
        "difficulty": "easy",
        "type": "time",
      },
      {
        "question": "When does the next part-time course begin?",
        "options": ["5th of April", "5th of May", "15th of May", "25th of May"],
        "correctAnswer": "5th of May",
        "difficulty": "medium",
        "type": "date",
      },
      {
        "question": "How long does the course run for?",
        "options": ["6 weeks", "8 weeks", "10 weeks", "12 weeks"],
        "correctAnswer": "8 weeks",
        "difficulty": "easy",
        "type": "duration",
      },

      // Financial Questions
      {
        "question": "What is the cost of the full course fee?",
        "options": ["£300", "£320", "£340", "£360"],
        "correctAnswer": "£320",
        "difficulty": "easy",
        "type": "number",
      },
      {
        "question": "What is the registration fee?",
        "options": ["£10", "£15", "£20", "£25"],
        "correctAnswer": "£20",
        "difficulty": "easy",
        "type": "number",
      },
      {
        "question": "What is the total cost mentioned?",
        "options": ["£320", "£330", "£340", "£350"],
        "correctAnswer": "£340",
        "difficulty": "medium",
        "type": "calculation",
      },
      {
        "question": "What is included in the course fee?",
        "options": [
          "Textbooks only",
          "Course materials only",
          "Both textbooks and materials",
          "Neither textbooks nor materials",
        ],
        "correctAnswer": "Course materials only",
        "difficulty": "medium",
        "type": "detail",
      },

      // Placement Test Questions
      {
        "question": "What must new students do before joining?",
        "options": [
          "Submit a writing sample",
          "Take a placement test",
          "Provide references",
          "Attend an interview",
        ],
        "correctAnswer": "Take a placement test",
        "difficulty": "easy",
        "type": "procedure",
      },
      {
        "question": "How long does the placement test take?",
        "options": [
          "About 15 minutes",
          "About 30 minutes",
          "About 45 minutes",
          "About 60 minutes",
        ],
        "correctAnswer": "About 30 minutes",
        "difficulty": "easy",
        "type": "duration",
      },
      {
        "question": "How can students take the placement test?",
        "options": [
          "In person at the college",
          "Online",
          "At a local library",
          "By telephone",
        ],
        "correctAnswer": "Online",
        "difficulty": "easy",
        "type": "procedure",
      },

      // Location Questions
      {
        "question": "Where is the college located?",
        "options": [
          "15 Greenway Road",
          "50 Greenway Road",
          "15 Greenway Street",
          "50 Greenway Street",
        ],
        "correctAnswer": "15 Greenway Road",
        "difficulty": "medium",
        "type": "address",
      },
      {
        "question": "What landmark is near the college?",
        "options": [
          "Central bus station",
          "Central train station",
          "City library",
          "Main shopping mall",
        ],
        "correctAnswer": "Central train station",
        "difficulty": "easy",
        "type": "location",
      },
      {
        "question": "How far is the college from the train station?",
        "options": [
          "2-minute walk",
          "5-minute walk",
          "10-minute walk",
          "15-minute walk",
        ],
        "correctAnswer": "5-minute walk",
        "difficulty": "easy",
        "type": "distance",
      },

      // Completion Questions
      {
        "question": "What does the college provide at the end of the course?",
        "options": [
          "A reference letter",
          "A certificate of completion",
          "A diploma",
          "A transcript",
        ],
        "correctAnswer": "A certificate of completion",
        "difficulty": "easy",
        "type": "detail",
      },
      {
        "question": "What information is included on the certificate?",
        "options": [
          "Final level and test scores",
          "Final level and attendance",
          "Teacher's comments and level",
          "Attendance and test scores",
        ],
        "correctAnswer": "Final level and attendance",
        "difficulty": "medium",
        "type": "detail",
      },

      // Registration Questions
      {
        "question": "How can the student register for the course?",
        "options": [
          "Only online",
          "Only in person",
          "Online or in person",
          "By telephone only",
        ],
        "correctAnswer": "Online or in person",
        "difficulty": "easy",
        "type": "procedure",
      },
      {
        "question": "When is the college open?",
        "options": [
          "Monday to Friday",
          "Monday to Saturday",
          "Tuesday to Saturday",
          "Every day",
        ],
        "correctAnswer": "Monday to Saturday",
        "difficulty": "easy",
        "type": "time",
      },
      {
        "question":
            "What does the receptionist say at the end of the conversation?",
        "options": [
          "Goodbye",
          "See you soon",
          "Good luck with your studies",
          "Have a nice day",
        ],
        "correctAnswer": "Good luck with your studies",
        "difficulty": "easy",
        "type": "conversation",
      },

      // Inference Questions
      {
        "question":
            "What can be inferred about the student's current English level?",
        "options": [
          "It's beginner level",
          "It's intermediate level",
          "It's advanced level",
          "The conversation doesn't say",
        ],
        "correctAnswer": "The conversation doesn't say",
        "difficulty": "hard",
        "type": "inference",
      },
      {
        "question": "What is the student's attitude toward the course?",
        "options": ["Hesitant", "Enthusiastic", "Indifferent", "Skeptical"],
        "correctAnswer": "Enthusiastic",
        "difficulty": "hard",
        "type": "attitude",
      },
      {
        "question": "What does the receptionist's tone suggest?",
        "options": ["Impatient", "Helpful", "Bored", "Formal"],
        "correctAnswer": "Helpful",
        "difficulty": "medium",
        "type": "tone",
      },
      {
        "question": "What is NOT mentioned about the course?",
        "options": ["Class size", "Course duration", "Schedule", "Cost"],
        "correctAnswer": "Class size",
        "difficulty": "medium",
        "type": "negative_detail",
      },
      {
        "question": "What would be the latest arrival time for classes?",
        "options": [
          "9:00 a.m.",
          "9:15 a.m.",
          "9:30 a.m.",
          "The conversation doesn't say",
        ],
        "correctAnswer": "The conversation doesn't say",
        "difficulty": "hard",
        "type": "inference",
      },
    ],
  },
];
