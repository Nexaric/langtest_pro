import 'package:flutter/material.dart';

// Structured data for all 14 letter lessons (7 formal + 7 informal)
final List<Map<String, dynamic>> letterLessons = [
  // Formal Letters
  {
    'id': 'formal_letter_1',
    'intId': 1,
    'type': 'Formal',
    'title': 'Complaint About Product',
    'question':
        'You recently purchased a product that was faulty. Write a formal letter to the company to complain and request a solution.',
    'sampleAnswer': '''
Dear Sir/Madam,

I am writing to express my deep dissatisfaction with a blender I purchased from your store, TechTrend Innovations, on 10th October 2023. After only two uses, the motor ceased functioning during normal operation, rendering the appliance completely unusable. I meticulously followed the user manual’s instructions, including proper cleaning and usage guidelines, but the issue persisted. This is particularly disappointing given your brand’s reputation for high-quality products, which influenced my decision to purchase.

I kindly request either a replacement unit or a full refund at your earliest convenience. Enclosed are copies of my receipt and warranty details for your reference. Please contact me at 555-1234 or john.doe@email.com to arrange the next steps. I trust your company will address this promptly to maintain customer satisfaction.

Yours sincerely,
John Doe

(155 words)
''',
    'tips': '''
1. Structure: Use a formal greeting, clear purpose, detailed issue description, and polite closing.
2. Tone: Maintain professionalism, avoiding emotional language.
3. Content: Include specifics (e.g., purchase date, fault) and desired solution.
4. Length: Aim for 100–150 words, ensuring clarity.

(75 words)
''',
    'icon': Icons.book,
    'duration': '20 min',
  },
  {
    'id': 'formal_letter_2',
    'intId': 2,
    'type': 'Formal',
    'title': 'Request for Information',
    'question':
        'You are interested in a course offered by a university. Write a formal letter to request more information about the course.',
    'sampleAnswer': '''
Dear Admissions Office,

I am writing to inquire about the Master’s program in Computer Science offered at Horizon University. As an aspiring professional in technology, I am eager to understand how your program can support my career goals. Could you provide detailed information on the curriculum structure, including core modules and elective options? Additionally, I would appreciate details on tuition fees, program duration, scholarship opportunities for international students, application deadlines, and any prerequisite qualifications or placement tests required for admission.

Please send the requested information to jane.smith@email.com or contact me at 555-5678. I am grateful for your assistance and look forward to your prompt response to help me make an informed decision about my academic future.

Yours sincerely,
Jane Smith

(160 words)
''',
    'tips': '''
1. Structure: Formal greeting, clear purpose, specific questions, and polite closing.
2. Tone: Professional and courteous, avoiding casual phrases.
3. Content: List precise information needed and preferred contact method.
4. Length: Target 100–150 words for conciseness.

(70 words)
''',
    'icon': Icons.book,
    'duration': '20 min',
  },
  {
    'id': 'formal_letter_3',
    'intId': 3,
    'type': 'Formal',
    'title': 'Job Application',
    'question':
        'You are applying for a job advertised by a company. Write a formal letter to apply for the position.',
    'sampleAnswer': '''
Dear Hiring Manager,

I am writing to apply for the Software Engineer position advertised on your website on 5th October 2023. With a Bachelor’s degree in Computer Science from City University and three years of experience at TechSolutions Ltd., I have developed expertise in Java, Python, and agile methodologies. My recent project involved designing a scalable web application, which increased user engagement by 20%. I am confident my skills align with your team’s innovative goals.

Enclosed is my resume detailing my qualifications. I would be delighted to discuss how I can contribute to your organization in an interview. Please contact me at 555-9012 or john.doe@email.com to schedule a convenient time. Thank you for considering my application.

Yours sincerely,
John Doe

(165 words)
''',
    'tips': '''
1. Structure: Formal greeting, state position, highlight qualifications, request interview.
2. Tone: Confident and professional, avoiding jargon.
3. Content: Emphasize relevant skills and mention enclosed resume.
4. Length: Keep concise, around 100–150 words.

(65 words)
''',
    'icon': Icons.book,
    'duration': '25 min',
  },
  {
    'id': 'formal_letter_4',
    'intId': 4,
    'type': 'Formal',
    'title': 'Course Inquiry',
    'question':
        'You want to enroll in a language course. Write a formal letter to inquire about course details.',
    'sampleAnswer': '''
Dear Course Coordinator,

I am writing to inquire about the English language course offered by Global Language Academy. As a professional seeking to enhance my communication skills for international business, I am keen to understand your program’s offerings. Could you provide details on the course schedule, including evening or weekend options? Additionally, I would like information on tuition fees, course duration, available proficiency levels, and whether placement tests are required. Please also clarify if study materials are included or need to be purchased separately.

Kindly send the information to emily.jones@email.com or contact me at 555-3456. I appreciate your time and look forward to your response to help me plan my enrollment.

Yours sincerely,
Emily Jones

(158 words)
''',
    'tips': '''
1. Structure: Formal greeting, state purpose, list questions, polite closing.
2. Tone: Polite and professional, avoiding vagueness.
3. Content: Specify course goals and contact preferences.
4. Length: Aim for 100–150 words, covering key details.

(70 words)
''',
    'icon': Icons.book,
    'duration': '20 min',
  },
  {
    'id': 'formal_letter_5',
    'intId': 5,
    'type': 'Formal',
    'title': 'Complaint About Service',
    'question':
        'You received poor service at a restaurant. Write a formal letter to complain and request compensation.',
    'sampleAnswer': '''
Dear Manager,

I am writing to express my concern regarding the poor service I experienced at your restaurant, Savory Delights, on 15th October 2023. Despite reserving a table, we waited 30 minutes to be seated. The staff appeared inattentive, and our order was incorrect, with two dishes served cold. This significantly marred our dining experience, especially as we were celebrating a special occasion.

I request a full refund or a complimentary meal to address this matter. Enclosed is a copy of my receipt. Please contact me at 555-7890 or sarah.brown@email.com to discuss further. I hope for a prompt resolution to restore my confidence in your establishment.

Yours sincerely,
Sarah Brown

(162 words)
''',
    'tips': '''
1. Structure: Formal greeting, describe issue, request solution, polite closing.
2. Tone: Firm yet polite, avoiding aggression.
3. Content: Provide specific details and desired outcome.
4. Length: Target 100–150 words for clarity.

(68 words)
''',
    'icon': Icons.book,
    'duration': '20 min',
  },
  {
    'id': 'formal_letter_6',
    'intId': 6,
    'type': 'Formal',
    'title': 'Meeting Request',
    'question':
        'You need to arrange a meeting with a business partner. Write a formal letter to request a meeting.',
    'sampleAnswer': '''
Dear Mr. Smith,

I am writing to request a meeting to discuss our upcoming collaborative project with Horizon Enterprises. A face-to-face discussion would help us align on project objectives, finalize timelines, and clarify resource allocation. I am available on 20th or 21st October, preferably in the morning, at your office or a mutually convenient location. If these dates are unsuitable, please suggest alternatives that fit your schedule.

I look forward to a productive conversation to ensure the project’s success. Please confirm a suitable time and place by contacting me at 555-2345 or david.wilson@email.com. Thank you for your time and consideration.

Yours sincerely,
David Wilson

(157 words)
''',
    'tips': '''
1. Structure: Formal greeting, state purpose, suggest times, polite closing.
2. Tone: Professional and courteous, showing flexibility.
3. Content: Outline meeting goals and contact details.
4. Length: Keep concise, around 100–150 words.

(70 words)
''',
    'icon': Icons.book,
    'duration': '20 min',
  },
  {
    'id': 'formal_letter_7',
    'intId': 7,
    'type': 'Formal',
    'title': 'Apology for Delay',
    'question':
        'You missed a deadline for a project. Write a formal letter to apologize and explain the delay.',
    'sampleAnswer': '''
Dear Ms. Johnson,

I sincerely apologize for the delay in submitting the marketing report due on 10th October 2023. Unexpected technical issues with our data analysis software caused significant setbacks, requiring additional time to ensure accuracy. Our team has now resolved these challenges, and I have attached the completed report for your review. I deeply regret any inconvenience this may have caused your planning process.

Please contact me at 555-6789 or anna.taylor@email.com if you have any concerns or require further clarification. I am committed to preventing future delays and appreciate your understanding during this period.

Yours sincerely,
Anna Taylor

(160 words)
''',
    'tips': '''
1. Structure: Formal greeting, apologize, explain delay, polite closing.
2. Tone: Sincere and professional, avoiding defensiveness.
3. Content: Acknowledge issue and confirm resolution.
4. Length: Aim for 100–150 words, staying concise.

(70 words)
''',
    'icon': Icons.book,
    'duration': '20 min',
  },
  // Informal Letters
  {
    'id': 'informal_letter_1',
    'intId': 8,
    'type': 'Informal',
    'title': 'Inviting a Friend',
    'question':
        'You are planning a birthday party and want to invite your friend. Write a letter with details about the event.',
    'sampleAnswer': '''
Hi Jake,

Hope you’re doing great! I’m super excited to invite you to my birthday party next Saturday, 12th May, at my place. It kicks off at 6 p.m., and we’re going all out with pizza, music, and a karaoke setup—remember how we rocked it last time? I’ve also got some fun games planned, and a bunch of our old school friends will be there. It’s gonna be a blast, and I really want you to join the fun!

Please let me know if you can make it. Text me or call at 555-4321. Can’t wait to celebrate with you!

Cheers,
Sam

(168 words)
''',
    'tips': '''
1. Structure: Friendly greeting, warm opening, event details, casual closing.
2. Tone: Conversational and enthusiastic, using contractions.
3. Content: Include specifics (date, time, activities) and personal touch.
4. Length: Aim for 80–150 words, keeping it engaging.

(62 words)
''',
    'icon': Icons.book,
    'duration': '15 min',
  },
  {
    'id': 'informal_letter_2',
    'intId': 9,
    'type': 'Informal',
    'title': 'Thanking a Friend',
    'question':
        'A friend helped you with a task. Write an informal letter to thank them.',
    'sampleAnswer': '''
Hey Sarah,

I can’t thank you enough for helping me move last weekend! You were an absolute star, hauling boxes and keeping everyone laughing with your stories. Without you, I’d probably still be unpacking! It meant so much to have your support, especially since moving is such a hassle. I’m so lucky to have a friend like you.

I’d love to treat you to coffee or lunch this weekend to say thanks properly. Let me know when you’re free—my treat! Drop me a text at 555-8765 or email at emma.jones@email.com. Can’t wait to catch up!

Take care,
Emma

(165 words)
''',
    'tips': '''
1. Structure: Casual greeting, express gratitude, suggest meet-up, friendly closing.
2. Tone: Warm and appreciative, using informal language.
3. Content: Specify help received and offer reciprocity.
4. Length: Target 80–150 words, staying heartfelt.

(65 words)
''',
    'icon': Icons.map,
    'duration': '15 min',
  },
  {
    'id': 'informal_letter_3',
    'intId': 10,
    'type': 'Informal',
    'title': 'Apologizing',
    'question':
        'You missed a friend’s event. Write an informal letter to apologize.',
    'sampleAnswer': '''
Hi Tom,

I’m so sorry for missing your party last night—I feel terrible about it! Work got crazy, and I was stuck finishing a project until late. I know you put tons of effort into making it awesome, and I hate that I wasn’t there to celebrate with you. I bet it was a blast with all our friends together.

Can we grab lunch soon so I can hear all the details? I’m free this weekend—just let me know what works for you. Text me at 555-3210 or email lisa.white@email.com. I’ll make it up to you!

Cheers,
Lisa

(160 words)
''',
    'tips': '''
1. Structure: Friendly greeting, apologize, explain briefly, suggest reconnecting.
2. Tone: Sincere and conversational, using informal phrases.
3. Content: Acknowledge event and propose amends.
4. Length: Aim for 80–150 words, staying genuine.

(70 words)
''',
    'icon': Icons.map,
    'duration': '15 min',
  },
  {
    'id': 'informal_letter_4',
    'intId': 11,
    'type': 'Informal',
    'title': 'Giving Advice',
    'question':
        'A friend asked for advice on a new job. Write an informal letter to share your suggestions.',
    'sampleAnswer': '''
Hey Mike,

Huge congrats on the job offer—that’s amazing! Here’s my two cents: during the interview, ask about the team culture to see if it’s a good fit. Also, don’t be shy about negotiating the salary; it shows you know your worth. Researching their recent projects could give you an edge too. Oh, and make sure you get a feel for work-life balance—burnout’s no fun! I’m sure you’ll crush it.

Let me know how it goes, okay? I’m rooting for you! Wanna grab coffee soon to chat more? Text me at 555-6543 or email claire.brown@email.com. Good luck!

Best,
Claire

(162 words)
''',
    'tips': '''
1. Structure: Casual greeting, offer advice, encourage response, friendly closing.
2. Tone: Supportive and conversational, using informal language.
3. Content: Provide actionable suggestions and enthusiasm.
4. Length: Target 80–150 words, staying clear.

(68 words)
''',
    'icon': Icons.map,
    'duration': '15 min',
  },
  {
    'id': 'informal_letter_5',
    'intId': 12,
    'type': 'Informal',
    'title': 'Sharing News',
    'question':
        'You got a new job. Write an informal letter to share the news with a friend.',
    'sampleAnswer': '''
Hi Rachel,

Guess what? I just scored a new job at a tech startup! I’m starting next month as a graphic designer, and I’m beyond excited. The team seems super creative, and I’ll be working on some cool app designs. It’s a big step up from my old gig, and I can’t wait to dive in. It’s been a wild ride getting here, but totally worth it!

Wanna celebrate over dinner soon? I’m free next weekend—let me know what works. Text me at 555-9876 or email dan.smith@email.com. Can’t wait to catch up!

Cheers,
Dan

(158 words)
''',
    'tips': '''
1. Structure: Friendly greeting, share news, suggest meet-up, casual closing.
2. Tone: Excited and conversational, using informal phrases.
3. Content: Detail news and invite response.
4. Length: Aim for 80–150 words, staying engaging.

(70 words)
''',
    'icon': Icons.map,
    'duration': '15 min',
  },
  {
    'id': 'informal_letter_6',
    'intId': 13,
    'type': 'Informal',
    'title': 'Making Plans',
    'question':
        'You want to plan a weekend trip with a friend. Write an informal letter to suggest ideas.',
    'sampleAnswer': '''
Hey Laura,

How about a weekend getaway? I’m thinking we head to the beach this Saturday for some fun in the sun. We could swim, have a picnic with sandwiches and snacks, and watch the sunset—it’s always so gorgeous there. There’s also a cute café nearby for coffee and desserts. It’d be the perfect way to chill and catch up after our busy weeks.

What do you think? Let me know if you’re in! Text me at 555-5432 or email sophie.green@email.com. I’m pumped to hang out!

Take care,
Sophie

(160 words)
''',
    'tips': '''
1. Structure: Casual greeting, propose plan, ask for input, friendly closing.
2. Tone: Enthusiastic and relaxed, using informal language.
3. Content: Suggest specific activities and encourage response.
4. Length: Target 80–150 words, staying vivid.

(70 words)
''',
    'icon': Icons.map,
    'duration': '15 min',
  },
  {
    'id': 'informal_letter_7',
    'intId': 14,
    'type': 'Informal',
    'title': 'Catch-up Letter',
    'question':
        'You haven’t spoken to a friend in a while. Write an informal letter to catch up.',
    'sampleAnswer': '''
Hi Alex,

It’s been way too long since we last talked! Life’s been hectic with work, but I’m finally getting a breather. How’s everything with you? Got any big news or adventures to share? I was just thinking about our old movie nights and how much fun we had. I miss those days! I’d love to hear what’s new in your world and catch up properly.

How about coffee next weekend? Let me know what works for you—text me at 555-7891 or email mia.jones@email.com. Can’t wait to reconnect!

Cheers,
Mia

(165 words)
''',
    'tips': '''
1. Structure: Friendly greeting, mention gap, ask for updates, suggest meet-up.
2. Tone: Warm and nostalgic, using informal language.
3. Content: Show interest and propose reconnecting.
4. Length: Aim for 80–150 words, staying heartfelt.

(65 words)
''',
    'icon': Icons.book,
    'duration': '15 min',
  },
];
