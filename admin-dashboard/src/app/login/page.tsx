import { login } from "./actions";

export default async function LoginPage({
  searchParams,
}: {
  searchParams: Promise<{ [key: string]: string | string[] | undefined }>;
}) {
  const resolvedParams = await searchParams;
  const message = typeof resolvedParams?.message === 'string' ? resolvedParams.message : null;

  return (
    <div className="flex w-full items-center justify-center min-h-[calc(100vh-4rem)] text-foreground">
      <div className="w-full max-w-md p-8 bento-card border border-white/10 rounded-2xl relative z-10 m-auto">
        <h1 className="text-3xl font-bold bg-gradient-to-r from-blue-400 to-cyan-400 bg-clip-text text-transparent text-center mb-2">
          StudyTok Admin
        </h1>
        <p className="text-zinc-500 text-center mb-8 text-sm">Secure Access Portal</p>
        <form className="flex-1 flex flex-col w-full justify-center gap-4 text-zinc-300" action={login}>
          <div className="flex flex-col gap-1.5">
            <label className="text-sm font-medium text-zinc-400" htmlFor="email">
              Email
            </label>
            <input
              className="rounded-xl px-4 py-3 bg-white/5 border border-white/10 text-white focus:outline-none focus:border-cyan-400 transition-colors"
              name="email"
              placeholder="admin@studytok.com"
              required
            />
          </div>
          <div className="flex flex-col gap-1.5">
            <label className="text-sm font-medium text-zinc-400" htmlFor="password">
              Password
            </label>
            <input
              className="rounded-xl px-4 py-3 bg-white/5 border border-white/10 text-white focus:outline-none focus:border-cyan-400 transition-colors"
              type="password"
              name="password"
              placeholder="••••••••"
              required
            />
          </div>
          <button className="bg-gradient-to-r from-blue-500 to-cyan-400 text-white rounded-xl px-4 py-3 mt-4 font-bold shadow-lg shadow-cyan-500/20 hover:shadow-cyan-500/40 hover:-translate-y-0.5 transition-all w-full">
            Sign In
          </button>
          {message && (
            <p className="mt-4 p-4 bg-rose-500/10 text-rose-400 border border-rose-500/20 text-center rounded-xl text-sm">
              {message}
            </p>
          )}
        </form>
      </div>
    </div>
  );
}
