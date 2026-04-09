import { createClient } from "@/lib/supabase/server";
import { FolderPlus, BookOpen, Trash2 } from "lucide-react";
import Link from "next/link";
import { createSubject, deleteSubject } from "@/lib/actions/content";

export const revalidate = 0;

export default async function ContentDashboard() {
  const supabase = await createClient();
  const { data: subjects } = await supabase.from("subjects").select("*").order("created_at", { ascending: false });

  return (
    <div className="space-y-8 animate-in fade-in slide-in-from-bottom-4 duration-700 p-8 h-full">
      <div className="flex justify-between items-end">
        <div>
          <h1 className="text-3xl font-bold text-white tracking-tight">Curriculum Management</h1>
          <p className="text-zinc-400 mt-2">Manage subjects, chapters, and lessons.</p>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        
        {/* Left Column: List of Subjects */}
        <div className="lg:col-span-2 grid grid-cols-1 md:grid-cols-2 gap-6">
          {subjects?.map((subject) => (
            <Link key={subject.id} href={`/content/${subject.id}`} className="block">
              <div className="bento-card relative group hover:border-cyan-500/30 transition-all overflow-hidden h-full">
                <div className="absolute top-0 right-0 p-4 opacity-5 group-hover:opacity-10 transition-opacity">
                  <BookOpen className="w-32 h-32" />
                </div>
                <div className="flex justify-between items-start mb-4">
                  <div className="w-12 h-12 rounded-xl flex-center shadow-lg" style={{ backgroundColor: `#${subject.color_hex}` }}>
                    <BookOpen className="w-6 h-6 text-white" />
                  </div>
                  <form action={async () => {
                    "use server";
                    await deleteSubject(subject.id);
                  }}>
                    <button className="p-2 bg-rose-500/10 text-rose-400 rounded-lg opacity-0 group-hover:opacity-100 transition-opacity hover:bg-rose-500/20">
                      <Trash2 className="w-4 h-4" />
                    </button>
                  </form>
                </div>
                <h3 className="text-xl font-bold text-white mb-2">{subject.name}</h3>
                <p className="text-zinc-400 text-sm mb-4 line-clamp-2">{subject.short_description}</p>
                <div className="flex gap-2">
                  <span className="text-xs px-2 py-1 rounded-md bg-white/5 border border-white/10 text-zinc-300">
                    {subject.academic_level}
                  </span>
                  <span className="text-xs px-2 py-1 rounded-md bg-white/5 border border-white/10 text-zinc-300">
                    {subject.grade}
                  </span>
                </div>
              </div>
            </Link>
          ))}
          {(!subjects || subjects.length === 0) && (
            <div className="col-span-2 p-12 border border-dashed border-white/10 rounded-2xl flex-center flex-col text-zinc-500">
              <BookOpen className="w-12 h-12 mb-4 opacity-20" />
              <p>No subjects found. Create one to get started.</p>
            </div>
          )}
        </div>

        {/* Right Column: Add Subject Form */}
        <div className="bento-card h-fit sticky top-8">
          <div className="flex items-center gap-3 mb-6">
            <div className="p-2 bg-cyan-500/20 rounded-lg">
              <FolderPlus className="w-5 h-5 text-cyan-400" />
            </div>
            <h2 className="text-lg font-bold text-white">New Subject</h2>
          </div>
          
          <form action={createSubject} className="space-y-4">
            <div>
              <label className="block text-xs font-medium text-zinc-400 mb-1">Subject Name</label>
              <input name="name" required placeholder="e.g. Advanced Physics" className="w-full bg-white/5 border border-white/10 rounded-xl px-4 py-2 text-white focus:outline-none focus:border-cyan-500 text-sm" />
            </div>
            <div>
              <label className="block text-xs font-medium text-zinc-400 mb-1">Short Description</label>
              <textarea name="short_description" required placeholder="A brief overview..." rows={3} className="w-full bg-white/5 border border-white/10 rounded-xl px-4 py-2 text-white focus:outline-none focus:border-cyan-500 text-sm resize-none" />
            </div>
            <div className="grid grid-cols-2 gap-4">
               <div>
                <label className="block text-xs font-medium text-zinc-400 mb-1">Academic Level</label>
                <select name="academic_level" className="w-full bg-[#18181b] border border-white/10 rounded-xl px-4 py-2 text-white focus:outline-none focus:border-cyan-500 text-sm appearance-none">
                  <option value="grades1to8">Grades 1-8</option>
                  <option value="oLevels">O-Levels</option>
                  <option value="aLevels">A-Levels</option>
                </select>
              </div>
              <div>
                <label className="block text-xs font-medium text-zinc-400 mb-1">Grade Level</label>
                <input name="grade" required placeholder="e.g. Grade 8" className="w-full bg-white/5 border border-white/10 rounded-xl px-4 py-2 text-white focus:outline-none focus:border-cyan-500 text-sm" />
              </div>
            </div>
             <div>
              <label className="block text-xs font-medium text-zinc-400 mb-1">Hex Color</label>
              <div className="flex gap-2">
                <span className="bg-white/5 border border-white/10 rounded-xl px-4 py-2 text-zinc-500 text-sm">#</span>
                <input name="color_hex" placeholder="EF4444" className="w-full bg-white/5 border border-white/10 rounded-xl px-4 py-2 text-white focus:outline-none focus:border-cyan-500 text-sm" />
              </div>
            </div>
            <button type="submit" className="w-full bg-white text-black font-semibold rounded-xl px-4 py-2 hover:bg-zinc-200 transition-colors mt-4 text-sm shadow-lg shadow-white/5">
              Create Subject
            </button>
          </form>
        </div>

      </div>
    </div>
  );
}
