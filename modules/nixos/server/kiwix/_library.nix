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
    devdocsJavascript = "devdocs_en_javascript_2026-07";
    devdocsLatex = "devdocs_en_latex_2026-08";
    devdocsMarkdown = "devdocs_en_markdown_2026-07";
    devdocsNix = "devdocs_en_nix_2026-07";
    devdocsOpengl = "devdocs_en_opengl_2026-07";
    devdocsR = "devdocs_en_r_2026-04";
    devdocsRust = "devdocs_en_rust_2026-07";
    devdocsSqlite = "devdocs_en_sqlite_2026-07";
    devdocsTypescript = "devdocs_en_typescript_2026-07";
  }
  ## LIBRETEXTS ##
  // builtins.mapAttrs (_: f: "libretexts/${f}") {
    libretextsBiz = "libretexts.org_en_biz_2026-01";
    libretextsMath = "libretexts.org_en_math_2026-01";
    libretextsPhys = "libretexts.org_en_phys_2026-01";
  }
  ## WIKIMEDIA ##
  // builtins.mapAttrs (_: f: "wikimedia/${f}") {
    wikibooksAll = "wikibooks_en_all_maxi_2026-04";
    wikipediaCS = "wikipedia_en_computer_maxi_2026-06";
    wikipediaKnots = "wikipedia_en_knots_maxi_2026-07";
    wikipediaMath = "wikipedia_en_mathematics_maxi_2026-06";

    wiktionaryAll = "wiktionary_en_all_nopic_2026-08";

    # chinese
    wikipediaYueAll = "wikipedia_yue_all_maxi_2026-06";
  }
  # these files don't live in a subdirectory
  // {
    archWiki = "archlinux_en_all_maxi_2026-07";
    stackexchangeChinese = "chinese.stackexchange.com_mul_all_2026-07";
    pythonDocs = "docs.python.org_en_all_2026-08";
    explainXkcd = "explainxkcd_en_all_maxi_2026-07";
    finiki = "finiki_en_all_maxi_2024-06";
    fossCooking = "foss.cooking_en_all_2026-05";
    freecodecampLessons = "freecodecamp_en_all_2026-08";
    freecodecampProjectEuler = "freecodecamp_en_project-euler_2026-08";
    gentooWiki = "gentoo_en_all_maxi_2026-07";
    ifixit = "ifixit_en_all_2025-12";
    openmusictheory = "openmusictheory.com_en_all_2026-06";
    opsecBible = "privacydefence.org_en_opsecbible_2026-06";
    xkcd = "xkcd.com_en_all_2026-08";
  }
)
