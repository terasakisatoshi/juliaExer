void fill_matrix(int **arr, int row, int col)
{
  for (int i=0; i<row; i++){
    for (int j=0; j<col; j++){
      arr[i][j] = arr[i][j] + i + j*10;
    }
  }
}