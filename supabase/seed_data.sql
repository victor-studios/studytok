-- Sample Seed Data for StudyTok Supabase
-- This inserts base subjects, chapters, and lessons for testing.

-- Define static UUIDs to preserve relational integrity across tables
DO $$
DECLARE
  sub_math UUID := '00000000-0000-4000-8000-000000000001';
  sub_physics UUID := '00000000-0000-4000-8000-000000000002';
  ch_math_1 UUID := '10000000-0000-4000-8000-000000000001';
  ch_phy_1 UUID := '20000000-0000-4000-8000-000000000001';
BEGIN

  -- 1. Subjects
  INSERT INTO subjects (id, name, short_description, icon_name, color_hex, academic_level, grade)
  VALUES 
    (sub_math, 'Mathematics (O Level)', 'Algebra, Geometry & Statistics', 'LucideIcons.calculator', '0xFF0F766E', 'grades9to10', 'O Level'),
    (sub_physics, 'Physics (O Level)', 'Forces, Energy & Motion', 'LucideIcons.zap', '0xFF60A5FA', 'grades9to10', 'O Level')
  ON CONFLICT (id) DO NOTHING;

  -- 2. Chapters
  INSERT INTO chapters (id, subject_id, title, description, order_index)
  VALUES 
    (ch_math_1, sub_math, 'Algebraic Fractions', 'Master complex algebraic expressions', 1),
    (ch_phy_1, sub_physics, 'Kinematics', 'Speed, velocity, and acceleration', 1)
  ON CONFLICT (id) DO NOTHING;

  -- 3. Lessons
  INSERT INTO lessons (
    id, chapter_id, subject_id, title, subtitle, chapter_title, 
    lesson_number, total_lessons_in_chapter, video_url, teacher_name, duration_seconds
  )
  VALUES 
    (
      uuid_generate_v4(), ch_math_1, sub_math, 
      'Simplifying Fractions', 'The core rules of simplification', 'Algebraic Fractions',
      1, 2, 'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4', 'Mr. Ahmed', 180
    ),
    (
      uuid_generate_v4(), ch_math_1, sub_math, 
      'Adding and Subtracting', 'Finding common denominators', 'Algebraic Fractions',
      2, 2, 'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4', 'Mr. Ahmed', 200
    ),
    (
      uuid_generate_v4(), ch_phy_1, sub_physics, 
      'Distance vs Displacement', 'Understanding vector directions', 'Kinematics',
      1, 1, 'https://storage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4', 'Ms. Sarah', 210
    );

END $$;
