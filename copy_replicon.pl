{
  "nbformat": 4,
  "nbformat_minor": 0,
  "metadata": {
    "colab": {
      "name": "copy_replicon.pl",
      "provenance": [],
      "collapsed_sections": [],
      "authorship_tag": "ABX9TyPE40K/4FsAVnusjBbh6ewv",
      "include_colab_link": true
    },
    "kernelspec": {
      "name": "python3",
      "display_name": "Python 3"
    },
    "language_info": {
      "name": "python"
    }
  },
  "cells": [
    {
      "cell_type": "markdown",
      "metadata": {
        "id": "view-in-github",
        "colab_type": "text"
      },
      "source": [
        "<a href=\"https://colab.research.google.com/github/vinsilico/INSeq_pipeline/blob/main/copy_replicon.pl\" target=\"_parent\"><img src=\"https://colab.research.google.com/assets/colab-badge.svg\" alt=\"Open In Colab\"/></a>"
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "MQXNwbovJaEe"
      },
      "source": [
        "open IN, \"output.txt\";\n",
        "@plus =<IN>;\n",
        "close IN;\n",
        "\n",
        "$replicon = \"pRL9\";\n",
        "$count = 0;\n",
        "open OUT, \">pRL9_BS.txt\";\n",
        "$count = 0;\n",
        "foreach $A (@plus)\n",
        "{\n",
        "         chomp($A);\n",
        "         @array = split(\"\\t\", $A);\n",
        "         if ($array[2] =~ m/$replicon/)\n",
        "         {\n",
        "         print OUT join (\"\\t\",@array), \"\\n\";\n",
        "         $count++;\n",
        "         }\n",
        "}\n",
        "print \"$count\\n\";\n",
        "close OUT;"
      ],
      "execution_count": null,
      "outputs": []
    }
  ]
}