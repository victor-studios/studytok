"use client";

import { useState, useEffect } from "react";
import { supabase } from "@/lib/supabase";
import { BookOpen, Folder, PlayCircle, Plus, Trash2, Edit2, Play } from "lucide-react";

export default function ContentManagerPage() {
  const [activeTab, setActiveTab] = useState<"subjects" | "chapters" | "lessons">("subjects");
  const [subjects, setSubjects] = useState<any[]>([]);
  const [chapters, setChapters] = useState<any[]>([]);
  const [lessons, setLessons] = useState<any[]>([]);
  const [isLoading, setIsLoading] = useState(true);

  // Form states
  const [subjectForm, setSubjectForm] = useState({ name: "", short_description: "", grade: "", academic_level: "grades9to10", icon_name: "LucideIcons.book", color_hex: "0xFF3B82F6" });
  const [chapterForm, setChapterForm] = useState({ subject_id: "", title: "", description: "", order_index: 1 });
  const [lessonForm, setLessonForm] = useState({ chapter_id: "", subject_id: "", title: "", subtitle: "", chapter_title: "", lesson_number: 1, total_lessons_in_chapter: 1, video_url: "", teacher_name: "" });

  useEffect(() => {
    fetchData();
  }, []);

  async function fetchData() {
    setIsLoading(true);
    const [subRes, chapRes, lesRes] = await Promise.all([
      supabase.from("subjects").select("*").order("created_at", { ascending: false }),
      supabase.from("chapters").select("*, subjects(name)").order("created_at", { ascending: false }),
      supabase.from("lessons").select("*, chapters(title), subjects(name)").order("created_at", { ascending: false })
    ]);
    if (subRes.data) setSubjects(subRes.data);
    if (chapRes.data) setChapters(chapRes.data);
    if (lesRes.data) setLessons(lesRes.data);
    setIsLoading(false);
  }

  async function handleAddSubject(e: React.FormEvent) {
    e.preventDefault();
    await supabase.from("subjects").insert([subjectForm]);
    setSubjectForm({ name: "", short_description: "", grade: "", academic_level: "grades9to10", icon_name: "LucideIcons.book", color_hex: "0xFF3B82F6" });
    fetchData();
  }

  async function handleAddChapter(e: React.FormEvent) {
    e.preventDefault();
    await supabase.from("chapters").insert([chapterForm]);
    setChapterForm({ subject_id: "", title: "", description: "", order_index: 1 });
    fetchData();
  }

  async function handleAddLesson(e: React.FormEvent) {
    e.preventDefault();
    await supabase.from("lessons").insert([lessonForm]);
    setLessonForm({ chapter_id: "", subject_id: "", title: "", subtitle: "", chapter_title: "", lesson_number: 1, total_lessons_in_chapter: 1, video_url: "", teacher_name: "" });
    fetchData();
  }

  async function handleDelete(table: string, id: string) {
    if (confirm("Are you sure you want to delete this item?")) {
      await supabase.from(table).delete().eq("id", id);
      fetchData();
    }
  }

  return (
    <div className="space-y-8 animate-in fade-in slide-in-from-bottom-4 duration-700">
      <div>
        <h1 className="text-3xl font-bold text-white tracking-tight flex items-center gap-3">
          <BookOpen className="w-8 h-8 text-indigo-400" />
          Content Manager
        </h1>
        <p className="text-zinc-400 mt-2">Add or edit classes, subjects, chapters, and lessons.</p>
      </div>

      <div className="flex gap-4 border-b border-white/10 pb-4">
        <button 
          onClick={() => setActiveTab("subjects")}
          className={`px-4 py-2 rounded-xl font-medium transition-colors ${activeTab === 'subjects' ? 'bg-indigo-500/20 text-indigo-300' : 'text-zinc-400 hover:text-white hover:bg-white/5'}`}
        >
          Classes & Subjects
        </button>
        <button 
          onClick={() => setActiveTab("chapters")}
          className={`px-4 py-2 rounded-xl font-medium transition-colors ${activeTab === 'chapters' ? 'bg-cyan-500/20 text-cyan-300' : 'text-zinc-400 hover:text-white hover:bg-white/5'}`}
        >
          Chapters
        </button>
        <button 
          onClick={() => setActiveTab("lessons")}
          className={`px-4 py-2 rounded-xl font-medium transition-colors ${activeTab === 'lessons' ? 'bg-emerald-500/20 text-emerald-300' : 'text-zinc-400 hover:text-white hover:bg-white/5'}`}
        >
          Lessons & Videos
        </button>
      </div>

      {isLoading ? (
        <div className="flex-center py-12 text-zinc-500">Loading data...</div>
      ) : (
        <div className="grid grid-cols-1 xl:grid-cols-3 gap-8">
          
          {/* Form Column */}
          <div className="xl:col-span-1 border border-white/10 glass rounded-2xl p-6 h-fit sticky top-8">
            <h2 className="text-xl font-semibold text-white mb-6 flex items-center gap-2">
              <Plus className="w-5 h-5 text-indigo-400" />
              Add New {activeTab === 'subjects' ? 'Subject' : activeTab === 'chapters' ? 'Chapter' : 'Lesson'}
            </h2>
            
            {activeTab === 'subjects' && (
              <form onSubmit={handleAddSubject} className="space-y-4">
                <div>
                  <label className="text-sm text-zinc-400 block mb-1">Class / Grade (e.g. O Level)</label>
                  <input required value={subjectForm.grade} onChange={e => setSubjectForm({...subjectForm, grade: e.target.value})} className="w-full bg-black/40 border border-white/10 rounded-lg px-3 py-2 text-white text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500/50" />
                </div>
                <div>
                  <label className="text-sm text-zinc-400 block mb-1">Subject Name</label>
                  <input required value={subjectForm.name} onChange={e => setSubjectForm({...subjectForm, name: e.target.value})} className="w-full bg-black/40 border border-white/10 rounded-lg px-3 py-2 text-white text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500/50" />
                </div>
                <div>
                  <label className="text-sm text-zinc-400 block mb-1">Description</label>
                  <input required value={subjectForm.short_description} onChange={e => setSubjectForm({...subjectForm, short_description: e.target.value})} className="w-full bg-black/40 border border-white/10 rounded-lg px-3 py-2 text-white text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500/50" />
                </div>
                <button type="submit" className="w-full bg-indigo-500 hover:bg-indigo-600 text-white rounded-lg px-4 py-2 font-medium transition-colors mt-6">
                  Save Subject
                </button>
              </form>
            )}

            {activeTab === 'chapters' && (
              <form onSubmit={handleAddChapter} className="space-y-4">
                <div>
                  <label className="text-sm text-zinc-400 block mb-1">Select Subject</label>
                  <select required value={chapterForm.subject_id} onChange={e => setChapterForm({...chapterForm, subject_id: e.target.value})} className="w-full bg-black/40 border border-white/10 rounded-lg px-3 py-2 text-white text-sm focus:outline-none focus:ring-2 focus:ring-cyan-500/50 [&>option]:bg-zinc-900">
                    <option value="">-- Choose Subject --</option>
                    {subjects.map(s => <option key={s.id} value={s.id}>{s.name} ({s.grade})</option>)}
                  </select>
                </div>
                <div>
                  <label className="text-sm text-zinc-400 block mb-1">Chapter Title</label>
                  <input required value={chapterForm.title} onChange={e => setChapterForm({...chapterForm, title: e.target.value})} className="w-full bg-black/40 border border-white/10 rounded-lg px-3 py-2 text-white text-sm focus:outline-none focus:ring-2 focus:ring-cyan-500/50" />
                </div>
                <div>
                  <label className="text-sm text-zinc-400 block mb-1">Description</label>
                  <textarea required value={chapterForm.description} onChange={e => setChapterForm({...chapterForm, description: e.target.value})} className="w-full bg-black/40 border border-white/10 rounded-lg px-3 py-2 text-white text-sm focus:outline-none focus:ring-2 focus:ring-cyan-500/50" rows={3}></textarea>
                </div>
                <button type="submit" className="w-full bg-cyan-600 hover:bg-cyan-700 text-white rounded-lg px-4 py-2 font-medium transition-colors mt-6">
                  Save Chapter
                </button>
              </form>
            )}

            {activeTab === 'lessons' && (
              <form onSubmit={handleAddLesson} className="space-y-4">
                <div>
                  <label className="text-sm text-zinc-400 block mb-1">Select Chapter</label>
                  <select required value={lessonForm.chapter_id} onChange={e => {
                      const chapId = e.target.value;
                      const chap = chapters.find(c => c.id === chapId);
                      setLessonForm({...lessonForm, chapter_id: chapId, subject_id: chap?.subject_id || "", chapter_title: chap?.title || ""});
                    }} className="w-full bg-black/40 border border-white/10 rounded-lg px-3 py-2 text-white text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500/50 [&>option]:bg-zinc-900">
                    <option value="">-- Choose Chapter --</option>
                    {chapters.map(c => <option key={c.id} value={c.id}>{c.title} ({c.subjects?.name})</option>)}
                  </select>
                </div>
                <div>
                  <label className="text-sm text-zinc-400 block mb-1">Lesson Title</label>
                  <input required value={lessonForm.title} onChange={e => setLessonForm({...lessonForm, title: e.target.value})} placeholder="e.g. Simplifying Fractions" className="w-full bg-black/40 border border-white/10 rounded-lg px-3 py-2 text-white text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500/50" />
                </div>
                <div>
                  <label className="text-sm text-zinc-400 block mb-1">Video URL (Optional)</label>
                  <input value={lessonForm.video_url} onChange={e => setLessonForm({...lessonForm, video_url: e.target.value})} placeholder="https://..." className="w-full bg-black/40 border border-white/10 rounded-lg px-3 py-2 text-white text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500/50" />
                </div>
                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <label className="text-sm text-zinc-400 block mb-1">Lesson #</label>
                    <input type="number" required value={lessonForm.lesson_number} onChange={e => setLessonForm({...lessonForm, lesson_number: parseInt(e.target.value)})} className="w-full bg-black/40 border border-white/10 rounded-lg px-3 py-2 text-white text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500/50" />
                  </div>
                  <div>
                    <label className="text-sm text-zinc-400 block mb-1">Total</label>
                    <input type="number" required value={lessonForm.total_lessons_in_chapter} onChange={e => setLessonForm({...lessonForm, total_lessons_in_chapter: parseInt(e.target.value)})} className="w-full bg-black/40 border border-white/10 rounded-lg px-3 py-2 text-white text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500/50" />
                  </div>
                </div>
                <button type="submit" className="w-full bg-emerald-600 hover:bg-emerald-700 text-white rounded-lg px-4 py-2 font-medium transition-colors mt-6">
                  Save Lesson
                </button>
              </form>
            )}

          </div>

          {/* List Column */}
          <div className="xl:col-span-2 space-y-4">
            {activeTab === 'subjects' && subjects.map(s => (
              <div key={s.id} className="bento-card p-4 flex justify-between items-center group">
                <div className="flex items-center gap-4">
                  <div className="w-12 h-12 rounded-xl bg-indigo-500/20 text-indigo-400 flex-center">
                    <BookOpen className="w-5 h-5" />
                  </div>
                  <div>
                    <h3 className="font-semibold text-lg text-white">{s.name}</h3>
                    <p className="text-sm text-zinc-400">{s.grade} • {s.short_description}</p>
                  </div>
                </div>
                <div className="flex gap-2">
                  <button onClick={() => handleDelete('subjects', s.id)} className="p-2 text-zinc-500 hover:text-red-400 hover:bg-red-400/10 rounded-lg transition-colors">
                    <Trash2 className="w-4 h-4" />
                  </button>
                </div>
              </div>
            ))}

            {activeTab === 'chapters' && chapters.map(c => (
              <div key={c.id} className="bento-card p-4 flex justify-between items-center group">
                <div className="flex items-center gap-4">
                  <div className="w-12 h-12 rounded-xl bg-cyan-500/20 text-cyan-400 flex-center">
                    <Folder className="w-5 h-5" />
                  </div>
                  <div>
                    <h3 className="font-semibold text-lg text-white">{c.title}</h3>
                    <p className="text-sm text-zinc-400">{c.subjects?.name} • {c.description}</p>
                  </div>
                </div>
                <div className="flex gap-2">
                  <button onClick={() => handleDelete('chapters', c.id)} className="p-2 text-zinc-500 hover:text-red-400 hover:bg-red-400/10 rounded-lg transition-colors">
                    <Trash2 className="w-4 h-4" />
                  </button>
                </div>
              </div>
            ))}

            {activeTab === 'lessons' && lessons.map(l => (
              <div key={l.id} className="bento-card p-4 flex justify-between items-center group">
                <div className="flex items-center gap-4">
                  <div className="w-12 h-12 rounded-xl bg-emerald-500/20 text-emerald-400 flex-center shrink-0">
                    <PlayCircle className="w-5 h-5" />
                  </div>
                  <div className="min-w-0">
                    <h3 className="font-semibold text-lg text-white truncate">{l.title}</h3>
                    <p className="text-sm text-zinc-400 truncate">{l.chapters?.title} • {l.subjects?.name}</p>
                    {l.video_url && (
                      <a href={l.video_url} target="_blank" rel="noreferrer" className="text-xs text-emerald-400 mt-1 inline-flex items-center gap-1 hover:underline">
                        <Play className="w-3 h-3" /> View Video
                      </a>
                    )}
                  </div>
                </div>
                <div className="flex gap-2 shrink-0">
                  <button onClick={() => handleDelete('lessons', l.id)} className="p-2 text-zinc-500 hover:text-red-400 hover:bg-red-400/10 rounded-lg transition-colors">
                    <Trash2 className="w-4 h-4" />
                  </button>
                </div>
              </div>
            ))}

            {/* Empty States */}
            {activeTab === 'subjects' && subjects.length === 0 && !isLoading && (
              <div className="text-center py-12 text-zinc-500 border border-dashed border-white/10 rounded-xl">No subjects created yet.</div>
            )}
            {activeTab === 'chapters' && chapters.length === 0 && !isLoading && (
              <div className="text-center py-12 text-zinc-500 border border-dashed border-white/10 rounded-xl">No chapters created yet.</div>
            )}
            {activeTab === 'lessons' && lessons.length === 0 && !isLoading && (
              <div className="text-center py-12 text-zinc-500 border border-dashed border-white/10 rounded-xl">No lessons created yet.</div>
            )}

          </div>

        </div>
      )}
    </div>
  );
}
