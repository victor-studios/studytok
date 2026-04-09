import { supabase } from "@/lib/supabase";
import { Users, BookOpen, PlayCircle, Trophy } from "lucide-react";

export const revalidate = 0; // Disable static caching for admin dashboard

async function getStats() {
  const [studentsReq, subjectsReq, lessonsReq] = await Promise.all([
    supabase.from("student_profiles").select("*", { count: "exact", head: true }),
    supabase.from("subjects").select("*", { count: "exact", head: true }),
    supabase.from("lessons").select("*", { count: "exact", head: true }),
  ]);

  return {
    students: studentsReq.count || 0,
    subjects: subjectsReq.count || 0,
    lessons: lessonsReq.count || 0,
  };
}

export default async function DashboardPage() {
  const stats = await getStats();

  return (
    <div className="space-y-8 animate-in fade-in slide-in-from-bottom-4 duration-700">
      <div>
        <h1 className="text-3xl font-bold text-white tracking-tight">Overview</h1>
        <p className="text-zinc-400 mt-2">Welcome to the StudyTok Admin Dashboard.</p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <StatCard
          title="Total Students"
          value={stats.students}
          icon={Users}
          color="from-blue-500 to-cyan-400"
        />
        <StatCard
          title="Active Classes/Subjects"
          value={stats.subjects}
          icon={BookOpen}
          color="from-emerald-400 to-teal-500"
        />
        <StatCard
          title="Video Lessons"
          value={stats.lessons}
          icon={PlayCircle}
          color="from-purple-500 to-indigo-500"
        />
        <StatCard
          title="System Health"
          value="100%"
          icon={Trophy}
          color="from-rose-400 to-orange-500"
        />
      </div>

      {/* Placeholder for Quick Actions or Recent Activity */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 mt-8">
        <div className="bento-card">
          <h2 className="text-xl font-semibold text-white mb-4">Quick Actions</h2>
          <div className="grid grid-cols-2 gap-4">
            <a href="/content" className="flex-center p-4 rounded-xl bg-white/5 border border-white/10 hover:bg-white/10 transition-colors text-sm font-medium text-white text-center">
              Add New Lesson
            </a>
            <a href="/content" className="flex-center p-4 rounded-xl bg-white/5 border border-white/10 hover:bg-white/10 transition-colors text-sm font-medium text-white text-center">
              Manage Subjects
            </a>
          </div>
        </div>
        <div className="bento-card">
          <h2 className="text-xl font-semibold text-white mb-4">Recent Registrations</h2>
          <div className="flex h-32 items-center justify-center border-2 border-dashed border-white/10 rounded-xl text-zinc-500 text-sm">
            Check the Students tab for detailed views.
          </div>
        </div>
      </div>
    </div>
  );
}

function StatCard({ title, value, icon: Icon, color }: any) {
  return (
    <div className="bento-card relative overflow-hidden group">
      <div className={`absolute top-0 right-0 p-4 opacity-10 group-hover:opacity-20 transition-opacity`}>
        <Icon className="w-24 h-24" />
      </div>
      <div className={`w-12 h-12 rounded-xl bg-gradient-to-br ${color} flex-center mb-6 shadow-lg shadow-white/5`}>
        <Icon className="w-6 h-6 text-white" />
      </div>
      <p className="text-zinc-400 text-sm font-medium mb-1">{title}</p>
      <h3 className="text-3xl font-bold text-white">{value}</h3>
    </div>
  );
}
