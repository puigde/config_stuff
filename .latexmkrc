# latexmkrc - Simple configuration for LaTeX with bibliography

# Default PDF generation using pdflatex
$pdf_mode = 1;

# Always run BibTeX/Biber when bbl files are out of date
$bibtex_use = 2;

# Run pdflatex with -synctex=1 for editor integration
$pdflatex = 'pdflatex -synctex=1 -interaction=nonstopmode -file-line-error %O %S';

# Run bibtex
$bibtex = 'bibtex %O %B';

# Number of passes
$max_repeat = 5;

# Clean extensions
$clean_ext = 'aux bbl blg brf idx ilg ind lof lot out toc acn acr alg glg glo gls fls log fdb_latexmk run.xml bcf nav snm vrb';

# Always process even if the output files are up to date
$force_mode = 1;

# Allow recursive processing of included files
$recursive = 1;

# Preview generated PDF after compilation
$preview_continuous_mode = 1;

# Settings
$xdvipdfmx = "xdvipdfmx -z 6 -i dvipdfmx-unsafe.cfg -o %D %O %S";

###############################
# Post processing of pdf file #
###############################
$compiling_cmd = "internal overleaf_pre_process %T %D";
$success_cmd = "internal overleaf_post_process %T %D";
$failure_cmd = $success_cmd;

# equivalent to -gt option. Used to prevent latexmk from skipping recompilation
# of output.log and output.pdf
$go_mode = 3;

my $ORIG_PDF_AGE;
sub overleaf_pre_process {
    my $source_file = $_[0];
    my $output_file = $_[1];
    # get age of existing pdf if present
    $ORIG_PDF_AGE = -M $output_file;
}

sub overleaf_post_process {
    my $source_file = $_[0];
    my $output_file = $_[1];
    my $source_without_ext = $source_file =~ s/\.tex$//r;
    my $output_without_ext = $output_file =~ s/\.pdf$//r;
    # Look for a knitr concordance file
    my $concordance_file = "${source_without_ext}-concordance.tex";
    if (-e $concordance_file) {
        print "Patching synctex file for knitr...\n";
        system("patchSynctex.R", $source_without_ext, $output_without_ext);
    }
    # Return early if pdf file doesn't exist or wasn't updated
    my $NEW_PDF_AGE = -M $output_file;
    return if !defined($NEW_PDF_AGE);
    return if defined($ORIG_PDF_AGE) && $NEW_PDF_AGE == $ORIG_PDF_AGE;
    # Figure out where qpdf is
    $qpdf //= "/usr/bin/qpdf";
    $qpdf = $ENV{QPDF} if defined($ENV{QPDF}) && -x $ENV{QPDF};
    return if ! -x $qpdf;
    $qpdf_opts //= "--linearize --newline-before-endstream";
    $qpdf_opts = $ENV{QPDF_OPTS} if defined($ENV{QPDF_OPTS});
    # Run qpdf
    my $optimised_file = "${output_file}.opt";
    system($qpdf, split(' ', $qpdf_opts), $output_file, $optimised_file);
    $qpdf_exit_code = ($? >> 8);
    print "qpdf exit code=$qpdf_exit_code\n";
    # Replace the output file if qpdf was successful
    # qpdf returns 0 for success, 3 for warnings (output pdf still created)
    return if !($qpdf_exit_code == 0 || $qpdf_exit_code == 3);
    print "Renaming optimised file to $output_file\n";
    rename($optimised_file, $output_file);
    print "Extracting xref table for $output_file\n";
    my $xref_file = "${output_file}xref";
    system("$qpdf --show-xref ${output_file} > ${xref_file}");
    $qpdf_xref_exit_code = ($? >> 8);
    print "qpdf --show-xref exit code=$qpdf_xref_exit_code\n";
}

##############
# Glossaries #
##############
add_cus_dep('glo', 'gls', 0, 'glo2gls');
add_cus_dep('acn', 'acr', 0, 'glo2gls'); # from Overleaf v1
sub glo2gls {
    system("makeglossaries $_[0]");
}

#############
# makeindex #
#############
@ist = glob("*.ist");
if (scalar(@ist) > 0) {
    $makeindex = "makeindex -s $ist[0] %O -o %D %S";
}

################
# nomenclature #
################
add_cus_dep("nlo", "nls", 0, "nlo2nls");
sub nlo2nls {
    system("makeindex $_[0].nlo -s nomencl.ist -o $_[0].nls -t $_[0].nlg");
}

#########
# Knitr #
#########
add_cus_dep('Rtex', 'tex', 0, 'do_knitr');
add_cus_dep('Rnw', 'tex', 0, 'do_knitr');
sub do_knitr {
    Run_subst(qq{Rscript -e '
        library("knitr");
        opts_knit\$set(concordance=T);
        knitr::knit(%S, output=%D);
    '});
}

