import type { MetadataRoute } from "next";

export default function manifest(): MetadataRoute.Manifest {
  return {
    name: "VisualMind AI School",
    short_name: "AI School",
    description:
      "Learn to make things with AI — one hands-on lesson at a time.",
    start_url: "/",
    display: "standalone",
    orientation: "portrait",
    background_color: "#17130f",
    theme_color: "#17130f",
    categories: ["education"],
    icons: [
      {
        src: "/icons/icon-192.png",
        sizes: "192x192",
        type: "image/png",
      },
      {
        src: "/icons/icon-512.png",
        sizes: "512x512",
        type: "image/png",
      },
      {
        src: "/icons/icon-maskable-512.png",
        sizes: "512x512",
        type: "image/png",
        purpose: "maskable",
      },
    ],
  };
}
