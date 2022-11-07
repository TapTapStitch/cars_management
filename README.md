# Requirements

- Ruby 3.1.2

# Setup

### 1.Install Ruby version 3.1.2 using rbenv

```bash
rbenv install 3.1.2
```

rbenv installation instruction:
https://devhints.io/rbenv

### 2.Clone the repository and go to the cars_management folder

```bash
git clone https://github.com/TapTapStitch/cars_management.git
cd cars_management
```

### 3.Install dependencies

```bash
bundle install
```

# Run the app

```bash
ruby index.rb
```

## Notes

* If you want the search history to only include your own search requests, clear `database/searches.yml` before first
  running the program