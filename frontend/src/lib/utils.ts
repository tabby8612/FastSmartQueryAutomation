import { clsx, type ClassValue } from "clsx"
import { twMerge } from "tailwind-merge"

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}

export function formatLongDate(isoString: string, includeTime = false) {
  if (!isoString) return "";

  const date = new Date(isoString);

  // Return empty or fallback if the date string is invalid
  if (isNaN(date.getTime())) return "Invalid Date";

  const options: Intl.DateTimeFormatOptions = {
    year: "numeric",
    month: "long",
    day: "numeric",
    ...(includeTime && {
      hour: "numeric",
      minute: "2-digit",
      hour12: true,
    }),
  };

  return new Intl.DateTimeFormat("en-US", options).format(date);
}