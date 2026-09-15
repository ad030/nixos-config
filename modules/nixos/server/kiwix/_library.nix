# all files live in /zim directory and have .zim extension
# remember to add leading slash
builtins.mapAttrs (_: f: "/zim/${f}.zim") (
  ## DEVDOCS ##
  builtins.mapAttrs (_: f: "devdocs/${f}") {
    devdocsBash = "devdocs_en_bash_2026-04";
    devdocsC = "devdocs_en_c_2026-07";
    devdocsCmake = "devdocs_en_cmake_2026-08";
    devdocsCpp = "devdocs_en_cpp_2026-07";
    devdocsDom = "devdocs_en_dom_2026-05";
    devdocsGcc = "devdocs_en_gcc_2026-08";
    devdocsGit = "devdocs_en_git_2026-07";
    devdocsGnuMake = "devdocs_en_gnu-make_2026-07";
    devdocsGodot = "devdocs_en_godot_2026-07";
    devdocsHttp = "devdocs_en_http_2026-07";
    devdocsJavascript = "devdocs_en_javascript_2026-07";
    devdocsLatex = "devdocs_en_latex_2026-08";
    devdocsMarkdown = "devdocs_en_markdown_2026-07";
    devdocsNix = "devdocs_en_nix_2026-07";
    devdocsOpengl = "devdocs_en_opengl_2026-07";
    devdocsR = "devdocs_en_r_2026-04";
    devdocsRust = "devdocs_en_rust_2026-07";
    devdocsSqlite = "devdocs_en_sqlite_2026-07";
    devdocsTypescript = "devdocs_en_typescript_2026-07";
    devdocsVulkan = "devdocs_en_vulkan_2026-07";
  }
  ## LIBRETEXTS ##
  // builtins.mapAttrs (_: f: "libretexts/${f}") {
    libretextsBiz = "libretexts.org_en_biz_2026-01";
    libretextsMath = "libretexts.org_en_math_2026-01";
    libretextsPhys = "libretexts.org_en_phys_2026-01";
  }
  ## WIKIPEDIA ##
  // builtins.mapAttrs (_: f: "wikimedia/${f}") {
    wikipediaCS = "wikipedia_en_computer_maxi_2026-06";
    wikipediaKnots = "wikipedia_en_knots_maxi_2026-07";
    wikipediaMath = "wikipedia_en_mathematics_maxi_2026-06";
    wikipediaAstronomy = "wikipedia_en_astronomy_maxi_2026-08";

    wikipediaYueAll = "wikipedia_yue_all_maxi_2026-06";
  }
  ## WIKTIONARY ##
  // builtins.mapAttrs (_: f: "wiktionary/${f}") {
    wiktionaryAll = "wiktionary_en_all_nopic_2026-08";
    wiktionaryZh = "wiktionary_zh_all_nopic_2025-04";
  }
  ## WIKIBOOKS ##
  // builtins.mapAttrs (_: f: "wikibooks/${f}") {
    wikibooksAll = "wikibooks_en_all_maxi_2026-04";
  }
  ## STACKEXCHANGE ##
  // builtins.mapAttrs (_: f: "stackexchange/${f}") {
    stackexchangeChinese = "chinese.stackexchange.com_mul_all_2026-07";
    stackexchangeCS = "cs.stackexchange.com_en_all_2026-07";
    stackexchangeSuperuser = "superuser.com_en_all_2026-08";
  }
  # these files don't live in a subdirectory
  // {
    archWiki = "archlinux_en_all_maxi_2026-07";
    cloudflareLearning = "cloudflare.com_en_learning-center_2025-12";
    pythonDocs = "docs.python.org_en_all_2026-08";
    explainXkcd = "explainxkcd_en_all_maxi_2026-07";
    finiki = "finiki_en_all_maxi_2024-06";
    fossCooking = "foss.cooking_en_all_2026-05";
    freecodecampLessons = "freecodecamp_en_all_2026-08";
    freecodecampProjectEuler = "freecodecamp_en_project-euler_2026-08";
    gentooWiki = "gentoo_en_all_maxi_2026-07";
    ifixit = "ifixit_en_all_2025-12";
    learningStatisticsR = "learningstatisticswithr.com_en_all_2026-08";
    luaDocs = "lua.org_en_all_2026-08";
    openmusictheory = "openmusictheory.com_en_all_2026-06";
    opsecBible = "privacydefence.org_en_opsecbible_2026-06";
    xkcd = "xkcd.com_en_all_2026-08";
  }
)
