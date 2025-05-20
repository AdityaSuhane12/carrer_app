import json

# Define which careers belong to each category
career_categories = {
    "Tech": ["Software Developer", "Data Scientist"],
    "Creative": ["UI/UX Designer", "Animator"],
    "Management": ["Project Manager", "Product Owner"],
    "Commerce": ["Financial Analyst", "Accountant"]
}

# Load questions from JSON
def load_questions():
    with open("questions.json") as f:
        return json.load(f)

# Analyze answers to recommend careers
def analyze_answers(selected_answers):
    questions = load_questions()
    scores = {key: 0 for key in career_categories.keys()}
    category_occurrences = {key: 0 for key in career_categories.keys()}

    for idx, answer in enumerate(selected_answers):
        if idx >= len(questions):
            continue

        options = questions[idx]["options"]
        if answer in options:
            for category, weight in options[answer].items():
                scores[category] += weight
                category_occurrences[category] += weight

    # Normalize scores based on category appearance (avoid bias)
    normalized_scores = {}
    for category in scores:
        if category_occurrences[category] > 0:
            normalized_scores[category] = scores[category] / category_occurrences[category]
        else:
            normalized_scores[category] = 0

    # Filter out zero-score categories
    non_zero_scores = {cat: score for cat, score in normalized_scores.items() if score > 0}
    if not non_zero_scores:
        return []

    # Sort by highest scores
    sorted_scores = sorted(non_zero_scores.items(), key=lambda x: x[1], reverse=True)

    # Get careers from top 2 categories
    top_careers = []
    for cat, _ in sorted_scores[:2]:
        top_careers.extend(career_categories[cat])

    return top_careers
