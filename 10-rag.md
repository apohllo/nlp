# RAG-based Question Answering

The exercise introduces modern approaches to Question Answering using Retrieval Augmented Generation (RAG) with LLMs and vector databases.

## Tasks

Objectives (8 points):

1. Set up the QA environment:
   * Install OLLAMA and select an appropriate LLM
   * Configure [Qdrant](https://qdrant.tech/) vector database (or vector DB of your choosing)
   * Install necessary Python packages for embedding generation
2. Find PDF file of your choosing. Example - some publication or CV file:
3. Write next procedures necessary for RAG pipeline. Use [LangChain](https://python.langchain.com/docs/introduction/) library:
 
   * Load PDF file using `PyPDFLoader`.  
   * Split documents into appropriate chunks using `RecursiveCharacterTextSplitter`.
   * Generate and store embeddings in Qdrant database
4. Design and implement the RAG pipeline with `LCEL`. As reference use this detailed guide created by LangChain community - [RAG](https://python.langchain.com/docs/tutorials/rag/). Next steps should involve:
   * Create query embedding generation
   * Implement semantic search in Qdrant
   * Design prompt templates for context integration
   * Build response generation with the LLM

Hint: You don't need to build it from scratch. A lot of this steps is already automated using LCEL pipeline definition.

5. Implement basic retrieval strategies (semantic search).
6. Create basic QA prompt.
7. Determine 5 evaluation queries:
    - Determine a few questions, which answers are confirmed by you.
8. Compare performance of RAG vs. pure LLM response.

Questions (2 points):

1. How does RAG improve the quality and reliability of LLM responses compared to pure LLM generation?
2. What are the key factors affecting RAG performance (chunk size, embedding quality, prompt design)?
3. How does the choice of vector database and embedding model impact system performance?
4. What are the main challenges in implementing a production-ready RAG system?
5. How can the system be improved to handle complex queries requiring multiple document lookups?

## Hints

1. Careful chunk size selection is crucial for relevant context retrieval
2. To select LLM for answer generation you can consult [LLM leaderboard](https://huggingface.co/spaces/open-llm-leaderboard/open_llm_leaderboard#/) or [Polish LLM Leaderboard](https://huggingface.co/spaces/speakleash/open_pl_llm_leaderboard).
3. To select model for retrieval (embedding generation) you can consul [Embedding leaderboard](https://huggingface.co/spaces/mteb/leaderboard) or [Polish embedding leaderboard](https://huggingface.co/spaces/sdadas/pirb).
4. Consider implementing re-ranking of retrieved documents
5. Prompt engineering significantly impacts answer quality
6. Caching can greatly improve system performance during development
7. Consider using metadata filtering to improve retrieval precision
8. The choice of embedding model affects both accuracy and speed
