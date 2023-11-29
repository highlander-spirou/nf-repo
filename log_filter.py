def join_filter(filter_crit):
    return '[' + filter_crit + ']'


def read_log(log_name, filter_tags):
    with open(log_name, 'r') as f:
        lines = f.readlines()

    log_lines = []
    for i in lines:
        for tag in filter_tags:
            if join_filter(tag) in i:
                log_lines.append(i)
            else:
                log_lines[-1] += i

    return log_lines

def filter_log(log_lines, loglevel):
    return [i for i in log_lines if loglevel in i]



import argparse


if __name__ == "__main__":
    # Create the argparse parser
    parser = argparse.ArgumentParser(description="Simple CLI App")

    # Add arguments to the parser
    parser.add_argument("input_name", type=str, help="Input path (default)")
    parser.add_argument("-o", "--output", type=str, default=None, help="Output file (default: None)")
    parser.add_argument("-l", "--loglevel", default="INFO", help="Log level to filter (default: INFO)")
    parser.add_argument('-f','--filter_tags', action='append', default='main', help='Set filter or list of filter (default: main)')

    # Parse the command-line arguments
    args = parser.parse_args()


    log_lines = read_log(args.input_name, args.filter_tags if type(args.filter_tags) == list else [args.filter_tags])
    filterd_log = filter_log(log_lines, args.loglevel)
    if args.output is None:
        for row in filterd_log:
            print(row)
    else:
        with open(args.output, 'w') as f:
            for row in filterd_log:
                f.write(row) 
