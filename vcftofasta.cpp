// Transform a vcf(second arg) into fasta( stdout) take reference on 1 arg 
#include <cctype>
#include <cstdio>
#include <fcntl.h>
#include <fstream>
#include <string>
#include <sys/mman.h>
#include <sys/stat.h>
#include <vector>
struct pos_nuc {
  int postions;
  std::vector<char> nuc;
};
void parse_lines(char *line_in, char *end, std::vector<pos_nuc> &out) {
  while (line_in != end) {
    std::vector<char> allele;
    int pos = 0;
    // Chromosome
    while (*line_in != '\t') {
      line_in++;
    }
    line_in++;
    // Position
    while (*line_in != '\t') {
      pos = pos * 10 + (*line_in - '0');
      line_in++;
    }
    out.push_back(pos_nuc{pos - 1, std::vector<char>()});
    auto &nucs = out.back().nuc;
    line_in++;
    // ID don't care
    while (*line_in != '\t') {
      line_in++;
    }
    line_in++;
    // REF
    allele.push_back(*line_in);
    line_in++;
    // assert(*line_in=='\t');
    line_in++;
    // ALT
    while (*line_in != '\t') {
      allele.push_back(*line_in);
      line_in++;
      if (*line_in == ',') {
        line_in++;
      } else {
        // assert(*line_in=='\t');
      }
    }
    line_in++;
    unsigned int field_idx = 5;
    for (; field_idx < 9; field_idx++) {
      while (*line_in != '\t') {
        line_in++;
      }
      line_in++;
    }
    // samples
    bool is_last = false;
    while (!is_last) {
      unsigned int allele_idx = (*line_in - '0');
      line_in++;
      while (std::isdigit(*line_in)) {
        allele_idx *= 10;
        allele_idx += (*line_in - '0');
        line_in++;
      }
      while (*line_in != '\t') {
        if (*line_in == '\n' || *line_in == 0) {
          is_last = true;
          break;
        }
        line_in++;
      }
      // output prototype of mutation, and a map from sample to non-ref
      // allele
      if (allele_idx >= (allele.size() + 1)) {
        nucs.push_back('N');
      } else {
        nucs.push_back(allele[allele_idx]);
      }
      field_idx++;
      line_in++;
    }
  }
}

// tokenize header, get sample name
static int read_header(char *&in, std::vector<std::string> &out) {
  int header_len = 0;
  bool second_char_pong = (*in == '#');

  while (second_char_pong) {
    while (*in != '\n') {
      in++;
    }
    in += 2;
    second_char_pong = (*in == '#');
  }

  bool eol = false;
  while (!eol) {
    std::string field;
    while (*in != '\t') {
      if (*in == '\n') {
        eol = true;
        break;
      }
      field.push_back(*in);
      in++;
      header_len++;
    }
    in++;
    out.push_back(field);
  }
  return header_len;
}
int main(int argc, char **argv) {
  std::ifstream fasta_f(argv[1]);
  std::string ref_header;
  std::getline(fasta_f, ref_header);
  std::string temp;
  std::string seq;
  while (fasta_f) {
    std::getline(fasta_f, temp);
    seq += temp;
  }
  struct stat stat_buf;
  auto vcf_fd = open(argv[2], O_RDONLY);
  fstat(vcf_fd, &stat_buf);
  char *vcf_start =
      (char *)mmap(0, stat_buf.st_size, PROT_READ, MAP_SHARED, vcf_fd, 0);
  std::perror("");
  auto vcf_end = vcf_start + stat_buf.st_size;
  std::vector<std::string> header;
  read_header(vcf_start, header);
  std::vector<pos_nuc> pos;
  parse_lines(vcf_start, vcf_end, pos);
  for (size_t samp_idx = 9; samp_idx < header.size(); samp_idx++) {
    int last_print = 0;
    fprintf(stdout, ">%s\n", header[samp_idx].c_str());
    for (int pos_idx = 0; pos_idx < pos.size(); pos_idx++) {
      std::fwrite(seq.data() + last_print, 1,
                  pos[pos_idx].postions - last_print, stdout);
      std::putc(pos[pos_idx].nuc[samp_idx - 9], stdout);
      last_print = pos[pos_idx].postions + 1;
    }
    std::fwrite(seq.data() + last_print, 1, seq.size() - last_print, stdout);
    std::puts("");
  }
  std::fwrite(ref_header.data(), 1, ref_header.size(), stdout);
  std::puts("");
  std::fwrite(seq.data(), 1, seq.size(), stdout);
  std::puts("");
}
