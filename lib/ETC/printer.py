import textwrap
import inspect

def print_columns_generic(categories, names, num_columns=3):
    # Determine the maximum width for each category
    category_widths = {category: max(len(name) for name in names) if names else 0 for category, names in categories.items()}

    # Define the width of each column
    column_width = max(category_widths.values()) + 4

    # Print the categorized names in columns
    for category, names in categories.items():
        print(f"{category}:".ljust(column_width))
        for i in range(0, len(names), num_columns):
            columns = names[i:i+num_columns]
            for name in columns:
                print(name.ljust(column_width), end='')
            print()
        print()

def print_columns(module_name, num_columns=3):
    # Get the module object
    module = __import__(module_name)

    # Get the names defined in the module
    module_names = dir(module)

    # Group the names into categories
    categories = {'Classes': [], 'Exceptions': [], 'Functions': [], 'Variables': []}

    for name in module_names:
        if inspect.isclass(getattr(module, name)):
            categories['Classes'].append(name)
        elif inspect.isfunction(getattr(module, name)):
            categories['Functions'].append(name)
        else:
            categories['Variables'].append(name)

    # Determine the maximum width for each category
    category_widths = {category: max(len(name) for name in names) if names else 0 for category, names in categories.items()}

    # Define the width of each column
    column_width = max(category_widths.values()) + 4

    # Print the categorized names in columns
    for category, names in categories.items():
        print(f"{category}:".ljust(column_width))
        for i in range(0, len(names), num_columns):
            columns = names[i:i+num_columns]
            for name in columns:
                print(name.ljust(column_width), end='')
            print()
        print()

