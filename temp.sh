git filter-repo --replace-refs update-or-add --commit-callback '
    from datetime import datetime, timezone, timedelta
    def parse_date(date_str):
        timestamp, offset_str = date_str.decode("utf-8").split()
        offset = int(offset_str[:-2]) * 60 + int(offset_str[-2:])
        tz = timezone(timedelta(minutes=offset))
        parsed_date = datetime.fromtimestamp(int(timestamp), tz=tz)
        print(f"Parsed date: {parsed_date}")
        return parsed_date
    def update_date(date):
        if 8 <= date.hour <= 18:
            updated_date = date.replace(hour=3)
            print(f"Updated date: {updated_date}")
            return updated_date.strftime("%s %z").encode("utf-8")
        else:
            return date.strftime("%s %z").encode("utf-8")
    commit.committer_date = update_date(parse_date(commit.committer_date))
    commit.author_date = update_date(parse_date(commit.author_date))
'
