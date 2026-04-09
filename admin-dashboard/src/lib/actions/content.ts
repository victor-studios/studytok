"use server";

import { createClient } from "@/lib/supabase/server";
import { revalidatePath } from "next/cache";

export async function createClass(formData: FormData) {
  const supabase = await createClient();
  const name = formData.get("name") as string;
  const description = formData.get("description") as string;
  const color_hex = formData.get("color_hex") as string || "3B82F6";
  const academic_level = formData.get("academic_level") as string;

  const { error } = await supabase.from("academic_classes").insert({
    name,
    description,
    color_hex,
    academic_level,
  });

  if (!error) revalidatePath("/content");
  return { error: error?.message };
}

export async function deleteClass(id: string) {
  const supabase = await createClient();
  const { error } = await supabase.from("academic_classes").delete().eq("id", id);
  if (!error) revalidatePath("/content");
  return { error: error?.message };
}

export async function createSubject(class_id: string, formData: FormData) {
  const supabase = await createClient();
  const name = formData.get("name") as string;
  const short_description = formData.get("short_description") as string;
  const icon_name = formData.get("icon_name") as string || "play_lesson_rounded";

  const { error } = await supabase.from("subjects").insert({
    class_id,
    name,
    short_description,
    icon_name,
  });

  if (!error) revalidatePath(`/content/${class_id}`);
  return { error: error?.message };
}

export async function deleteSubject(class_id: string, id: string) {
  const supabase = await createClient();
  const { error } = await supabase.from("subjects").delete().eq("id", id);
  if (!error) revalidatePath(`/content/${class_id}`);
  return { error: error?.message };
}

export async function createChapter(class_id: string, subject_id: string, formData: FormData) {
  const supabase = await createClient();
  const title = formData.get("title") as string;
  const description = formData.get("description") as string;
  
  const { data: maxOrderData } = await supabase
    .from("chapters")
    .select("order_index")
    .eq("subject_id", subject_id)
    .order("order_index", { ascending: false })
    .limit(1);
    
  const order_index = maxOrderData?.[0] ? maxOrderData[0].order_index + 1 : 0;

  const { error } = await supabase.from("chapters").insert({
    subject_id,
    title,
    description,
    order_index,
  });

  if (!error) revalidatePath(`/content/${class_id}/${subject_id}`);
  return { error: error?.message };
}

export async function createLesson(class_id: string, subject_id: string, chapter_id: string, chapter_title: string, formData: FormData) {
  const supabase = await createClient();
  const title = formData.get("title") as string;
  const subtitle = formData.get("subtitle") as string;
  const video_url = formData.get("video_url") as string;
  const teacher_name = formData.get("teacher_name") as string;
  const duration_seconds = parseInt(formData.get("duration_seconds") as string) || 180;
  
  const { count } = await supabase.from("lessons").select("*", { count: "exact" }).eq("chapter_id", chapter_id);
  const lesson_number = (count || 0) + 1;

  const { error } = await supabase.from("lessons").insert({
    subject_id,
    chapter_id,
    chapter_title,
    title,
    subtitle,
    video_url,
    teacher_name,
    duration_seconds,
    lesson_number,
    total_lessons_in_chapter: lesson_number
  });

  if (!error) {
     await supabase.from("lessons").update({ total_lessons_in_chapter: lesson_number }).eq("chapter_id", chapter_id);
     revalidatePath(`/content/${class_id}/${subject_id}/${chapter_id}`);
  }
  return { error: error?.message };
}
