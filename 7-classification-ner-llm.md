# NER and Classification with LLMs

The exercise demonstrates how to leverage Large Language Models for NER and text classification tasks, comparing their performance with traditional approaches.

## Tasks

Objectives (8 points):

1. Install and configure [OLLama](https://ollama.com/) with an appropriate LLM model (e.g. models from: Llama, Mistral, Bielik, Phi families). Rather not use models above 10B paramters.
Sample LLM run command, when OLLama is installed: `ollama run phi3:3.8b`
2. Take 1 thousand random passages from the FIQA-PL corpus. INFO: You can play with new dataset, but it will be necessary to create baseline results (next excersise).
3. As baseline use traditional NER methods from lab 7 - SpaCy.
4. Design prompts for the LLM to:
   * Identify named entities in text
   * Classify them into predefined categories (person, organization, location, etc.)
5. Implement prompt variations to compare performance:
   * Zero-shot prompting
   * Few-shot prompting with 3-5 examples
6. Compare results between:
   * Traditional NER (SpaCy)
   * Pure LLM-based approach
7. Build a simple evaluation pipeline:
   * Manually annotate 20 passages for ground truth (ideally, share those annotated passages in the group, so everyone have much more than 20)
   * Compute precision, recall, and F1 score for each approach
   * Analyze error patterns and classification mistakes

Questions (2 points):

1. How does the performance of LLM-based NER compare to traditional approaches? What are the trade-offs in terms of accuracy, speed, and resource usage?
2. Which prompting strategy proved most effective for NER and classification tasks? Why?
3. What are the limitations and potential biases of using LLMs for NER and classification?
4. In what scenarios would you recommend using traditional NER vs. LLM-based approaches?

## Hints

1. Consider using prompt templates and systematic prompt engineering approaches
2. The quality of results heavily depends on the model size and prompt design
3. Consider implementing caching for LLM responses to speed up development
4. Pay attention to rate limits and resource usage when working with LLMs
