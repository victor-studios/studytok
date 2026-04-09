-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Table: subjects
CREATE TABLE subjects (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  short_description TEXT NOT NULL,
  icon_name TEXT NOT NULL,
  color_hex TEXT NOT NULL,
  academic_level TEXT NOT NULL,
  grade TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table: chapters
CREATE TABLE chapters (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  subject_id UUID NOT NULL REFERENCES subjects(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  order_index INTEGER NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table: lessons
CREATE TABLE lessons (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  chapter_id UUID NOT NULL REFERENCES chapters(id) ON DELETE CASCADE,
  subject_id UUID NOT NULL REFERENCES subjects(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  subtitle TEXT NOT NULL,
  chapter_title TEXT NOT NULL,
  lesson_number INTEGER NOT NULL,
  total_lessons_in_chapter INTEGER NOT NULL,
  video_url TEXT,
  thumbnail_url TEXT,
  transcript TEXT,
  key_points TEXT[] DEFAULT '{}',
  formulas TEXT[] DEFAULT '{}',
  duration_seconds INTEGER NOT NULL DEFAULT 180,
  teacher_name TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table: student_profiles
CREATE TABLE student_profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  email TEXT,
  phone TEXT,
  avatar_url TEXT,
  academic_tier TEXT NOT NULL,
  current_grade TEXT NOT NULL,
  enrolled_subject_ids UUID[] DEFAULT '{}',
  current_streak INTEGER DEFAULT 0,
  total_study_minutes INTEGER DEFAULT 0,
  joined_date TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table: user_lesson_state
CREATE TABLE user_lesson_state (
  user_id UUID NOT NULL REFERENCES student_profiles(id) ON DELETE CASCADE,
  lesson_id UUID NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
  is_completed BOOLEAN DEFAULT false,
  is_bookmarked BOOLEAN DEFAULT false,
  PRIMARY KEY (user_id, lesson_id),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE subjects ENABLE ROW LEVEL SECURITY;
ALTER TABLE chapters ENABLE ROW LEVEL SECURITY;
ALTER TABLE lessons ENABLE ROW LEVEL SECURITY;
ALTER TABLE student_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_lesson_state ENABLE ROW LEVEL SECURITY;

-- Anonymous reads allowed for public curriculum
CREATE POLICY "Public read subjects" ON subjects FOR SELECT USING (true);
CREATE POLICY "Public read chapters" ON chapters FOR SELECT USING (true);
CREATE POLICY "Public read lessons" ON lessons FOR SELECT USING (true);

-- Authenticated Users Policies
CREATE POLICY "Users can manage own profile" ON student_profiles 
  FOR ALL USING (auth.uid() = id);

CREATE POLICY "Users can manage own progress" ON user_lesson_state 
  FOR ALL USING (auth.uid() = user_id);
