function [header, freq, data] = read_s2p (fname)
##  Read s2p file.
##
##  File is composed of N records of 2-port network data.
##  Minimal validation of data is done. Correctness of the data is
##  responsibility of the programmer creating the s2p file.
##
##  Returns
##  header : struct
##      Options of the Touchstone format.
##      Fields
##      units : string
##          Frequency units: "GHz", "MHz", "KHz", "Hz".
##      kind : string
##          Kind of network parameter: "S", "Y", "Z", "H", "G".
##      format : string
##          Format of the parameter data: "DB" (db/angle),
##          "MA" (magnitude/angle), "RI" (real/image).
##          Attention:  accordingly to Touchstone format, angles are given in
##                      degrees!
##      R : positive real number
##          Resistance in ohms.
##  freq : real column vector
##      Signal frequencies.
##  data : real matrix of shape (N, 8)
##      Columns describe network parameter data (in pairs).

    ## For 2-ports variation we have 9 columns in file.
    num_cols = 9;
    ## Count how many lines of each types exist.
    [num_comments, num_headers, num_data_entries] = count_lines (fname);
    if num_headers != 1
        error ("Missing or extra header")
    endif
    ## Set an alias for number of data lines.
    N = num_data_entries;
    data = zeros (N, num_cols-1);
    freq = zeros (N, 1);
    tmprow = zeros (1, num_cols);
    fid = fopen (fname, "r");
    ## Index for the current line of data.
    ind = 0;
    while (! feof (fid))
        aLine = fgetl (fid);
        switch aLine(1)
            case "!"
                ## ignore
            case "#"
                header_line = aLine;
            otherwise
                ind += 1;
                tmprow(:) = sscanf (aLine, "%f", num_cols);
                freq(ind) = tmprow(1);
                data(ind, :) = tmprow(2:end);
        endswitch
    endwhile
    fclose (fid);
    header = parse_header (header_line);
endfunction
 
function header = parse_header (header_line)
##  Create header structure from header line
##
##  The header line is supposed to be of the form:
##      # <units:str> <kind:str> <format:str> R <resistance:int>
    chunks = strsplit (strtrim (header_line))';  # Transposed!
    wrong_start = (cell2mat (chunks(1, 1)) != "#");
    not_R = (cell2mat (chunks(5, 1)) != "R") && (cell2mat (chunks(5, 1)) != "r");
    wrong_size = (size (chunks, 1) != 6);
    if (wrong_start || not_R || wrong_size)
        msg = sprintf ("Wrong header format. Header: \"%s\"", header_line);
        error (msg)
    endif
    header = cell2struct (chunks(2:4, 1), {"units", "kind", "format"}, 1);
    header.resistance = str2num (cell2mat (chunks(6, 1)));
endfunction
 
function [num_comments, num_headers, num_data_entries] = count_lines (fname)
##  Count number of comment, header and data lines in file.
##
##  Comment line starts with "!", header line starts with "#", other lines area
##  are supposed to be data lines.
    num_comments = 0;
    num_headers = 0;
    num_data_entries = 0;
    fid = fopen (fname, "r");
    while (! feof (fid))
        aLine = fgetl (fid);
        switch aLine(1)
            case "!"
                num_comments += 1;
            case "#"
                num_headers += 1;
            otherwise
                num_data_entries += 1;
        endswitch
    endwhile
    fclose(fid);
endfunction
