function [header, data] = read_s2p (fname)
    ## For 2-ports variation we have 9 columns.
    num_cols = 9;
    ## Count how many lines of each types exist.
    [num_comments, num_headers, num_data_entries] = count_lines (fname);
    if num_headers != 1
        error ("Missing or extra header")
    endif
    ## Set an alias for number of data lines.
    N = num_data_entries;
    data = zeros (N, num_cols);
    fid = fopen (fname, "r");
    ## Index for the current line of data.
    ind = 0;
    while (! feof(fid))
        aLine = fgetl(fid);
        switch aLine(1)
            case "!"
                ## ignore
            case "#"
                header_line = aLine;
            otherwise
                ind += 1;
                data(ind, :) = sscanf (aLine, "%f", num_cols);
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
    chunks = strsplit (header_line)';  # Transposed!
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
